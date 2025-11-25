import json
import boto3
import os
import jwt

SECRET_KEY = os.getenv("JWT_SECRET", "supersecretkey")
dynamodb = boto3.resource("dynamodb", endpoint_url=os.getenv("DYNAMODB_ENDPOINT"))
images_table = dynamodb.Table(os.getenv("IMAGES_TABLE"))
s3 = boto3.client("s3", endpoint_url=os.getenv("S3_ENDPOINT"))
bucket_name = os.getenv("S3_BUCKET")

def lambda_handler(event, context):
    auth_header = event.get("headers", {}).get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        return {"statusCode": 401, "body": json.dumps({"error": "Missing token"})}

    token = auth_header.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    except jwt.InvalidTokenError:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid token"})}

    user_id = payload["userId"]
    is_superadmin = payload.get("role") == "superadmin"
    
    image_id = event.get("pathParameters", {}).get("image_id")
    if not image_id:
        return {"statusCode": 400, "body": json.dumps({"error": "image_id required"})}
    
    response = images_table.get_item(Key={"imageId": image_id})
    item = response.get("Item")
    if not item:
        return {"statusCode": 404, "body": json.dumps({"error": "Image not found"})}
    
    if item["userId"] != user_id and not is_superadmin:
        return {"statusCode": 403, "body": json.dumps({"error": "Forbidden"})}

    key = item["key"]
    url = s3.generate_presigned_url(
        "get_object",
        Params={"Bucket": bucket_name, "Key": key},
        ExpiresIn=3600
    )
    
    return {"statusCode": 200, "body": json.dumps({"download_url": url})}
