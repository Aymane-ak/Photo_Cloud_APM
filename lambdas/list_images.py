import json
import boto3
import os
import jwt
from boto3.dynamodb.conditions import Key

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
    
    user_id = payload["userId"]
    
    response = table.query(
        IndexName="userIdIndex",
        KeyConditionExpression=Key("userId").eq(user_id)
    )
    images = response.get("Items", [])
    
    return {"statusCode": 200, "body": json.dumps({"images": images})}
