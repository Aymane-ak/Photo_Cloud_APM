import json
import boto3
import hashlib
import os
import jwt
from datetime import datetime, timedelta

# DynamoDB
dynamodb = boto3.resource('dynamodb', endpoint_url=os.getenv('DYNAMODB_ENDPOINT'))
table = dynamodb.Table(os.getenv('USERS_TABLE'))

# JWT secret
SECRET_KEY = os.getenv('JWT_SECRET', 'supersecretkey')

def lambda_handler(event, context):
    body = json.loads(event.get("body", "{}"))
    email = body.get("username")  # ici "username" = email
    password = body.get("password")

    if not email or not password:
        return {"statusCode": 400, "body": json.dumps({"error": "Username and password required"})}

    # Récupérer l'utilisateur via email-index
    response = table.query(
        IndexName="email-index",
        KeyConditionExpression=boto3.dynamodb.conditions.Key("email").eq(email)
    )
    items = response.get("Items")
    if not items:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid credentials"})}

    user = items[0]
    password_hash = hashlib.sha256(password.encode()).hexdigest()

    if user["password_hash"] != password_hash:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid credentials"})}

    # Créer JWT
    payload = {
        "username": email,
        "role": user.get("role", "user"),
        "exp": datetime.utcnow() + timedelta(hours=1)
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")

    return {"statusCode": 200, "body": json.dumps({"token": token})}
