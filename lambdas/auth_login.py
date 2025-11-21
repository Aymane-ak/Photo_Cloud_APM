import json
import boto3
import hashlib
import os
import jwt
from datetime import datetime, timedelta

dynamodb = boto3.resource('dynamodb', endpoint_url=os.getenv('DYNAMODB_ENDPOINT'))
table = dynamodb.Table(os.getenv('USERS_TABLE'))

SECRET_KEY = os.getenv('JWT_SECRET', 'supersecretkey')

def lambda_handler(event, context):
    body = json.loads(event.get("body", "{}"))
    username = body.get("username")
    password = body.get("password")
    
    if not username or not password:
        return {"statusCode": 400, "body": json.dumps({"error": "Username and password required"})}
    
    response = table.get_item(Key={"username": username})
    user = response.get("Item")
    
    if not user:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid credentials"})}
    
    password_hash = hashlib.sha256(password.encode()).hexdigest()
    if user["password_hash"] != password_hash:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid credentials"})}
    
    # Créer JWT
    payload = {
        "username": username,
        "role": user.get("role", "user"),
        "exp": datetime.utcnow() + timedelta(hours=1)
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")
    
    return {"statusCode": 200, "body": json.dumps({"token": token})}
