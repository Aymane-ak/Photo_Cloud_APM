import json
import boto3
import os
import jwt

SECRET_KEY = os.getenv('JWT_SECRET', 'supersecretkey')
dynamodb = boto3.resource('dynamodb', endpoint_url=os.getenv('DYNAMODB_ENDPOINT'))
table = dynamodb.Table(os.getenv('IMAGES_TABLE'))

def lambda_handler(event, context):
    auth_header = event.get("headers", {}).get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        return {"statusCode": 401, "body": json.dumps({"error": "Missing token"})}

    token = auth_header.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    except jwt.InvalidTokenError:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid token"})}

    body = json.loads(event.get("body", "{}"))
    image_id = body.get("image_id")
    new_filename = body.get("filename")

    if not image_id or not new_filename:
        return {"statusCode": 400, "body": json.dumps({"error": "image_id and filename required"})}

    response = table.get_item(Key={"imageId": image_id})
    item = response.get("Item")
    if not item or item["userId"] != payload["userId"]:
        return {"statusCode": 403, "body": json.dumps({"error": "Forbidden"})}

    # Mettre à jour le nom dans DynamoDB
    table.update_item(
        Key={"imageId": image_id},
        UpdateExpression="SET #f = :f",
        ExpressionAttributeNames={"#f": "filename"},
        ExpressionAttributeValues={":f": new_filename}
    )

    return {"statusCode": 200, "body": json.dumps({"message": "Filename updated"})}
