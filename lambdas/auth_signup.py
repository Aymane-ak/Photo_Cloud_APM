import json
import boto3
import hashlib
import os
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb', endpoint_url=os.getenv('DYNAMODB_ENDPOINT'))
table = dynamodb.Table(os.getenv('USERS_TABLE'))

def lambda_handler(event, context):
    raw_body = event.get("body", "{}")
    body = raw_body if isinstance(raw_body, dict) else json.loads(raw_body)

    email = body.get("email")
    password = body.get("password")

    if not email or not password:
        return {"statusCode": 400, "body": json.dumps({"error": "Email and password required"})}

    # Vérifie si l'email existe déjà
    response = table.query(
        IndexName="email-index",
        KeyConditionExpression=boto3.dynamodb.conditions.Key("email").eq(email)
    )
    if response.get("Items"):
        return {"statusCode": 409, "body": json.dumps({"error": "Email already exists"})}

    user_id = str(uuid.uuid4())
    password_hash = hashlib.sha256(password.encode()).hexdigest()

    table.put_item(Item={
        "userId": user_id,
        "email": email,
        "password_hash": password_hash,
        "role": "user",
        "created_at": datetime.utcnow().isoformat()
    })

    return {"statusCode": 201, "body": json.dumps({"message": "User created", "userId": user_id})}
