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
    if not image_id:
        return {"statusCode": 400, "body": json.dumps({"error": "image_id required"})}
    
    # Mettre à jour le status en 'uploaded'
    table.update_item(
        Key={"image_id": image_id},
        UpdateExpression="SET #s = :s",
        ExpressionAttributeNames={"#s": "status"},
        ExpressionAttributeValues={":s": "uploaded"}
    )
    
    return {"statusCode": 200, "body": json.dumps({"message": "Image confirmed"})}
