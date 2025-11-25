import json
import boto3
import hashlib
import os
import jwt
from datetime import datetime, timedelta
from boto3.dynamodb.conditions import Key

# DynamoDB
dynamodb = boto3.resource("dynamodb", endpoint_url=os.getenv("DYNAMODB_ENDPOINT"))
table = dynamodb.Table(os.getenv("USERS_TABLE"))

SECRET_KEY = os.getenv("JWT_SECRET", "supersecretkey")

def lambda_handler(event, context):
    # Parse body
    try:
        raw = event.get("body", "{}")
        body = raw if isinstance(raw, dict) else json.loads(raw)
    except Exception:
        return {"statusCode": 400, "body": json.dumps({"error": "Invalid JSON"})}

    email = body.get("email")
    password = body.get("password")

    if not email or not password:
        return {"statusCode": 400, "body": json.dumps({"error": "Email and password required"})}

    # Query by email (GSI)
    try:
        response = table.query(
            IndexName="email-index",
            KeyConditionExpression=Key("email").eq(email)
        )
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({
            "error": "DynamoDB query failed",
            "details": str(e)
        })}

    items = response.get("Items", [])
    if not items:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid credentials"})}

    user = items[0]

    # Check password
    password_hash = hashlib.sha256(password.encode()).hexdigest()
    if user.get("password_hash") != password_hash:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid credentials"})}

    # Generate JWT
    payload = {
        "userId": user["userId"],
        "email": email,
        "role": user.get("role", "user"),
        "exp": datetime.utcnow() + timedelta(hours=1)
    }

    token = jwt.encode(payload, SECRET_KEY, algorithm="HS256")

    return {
        "statusCode": 200,
        "body": json.dumps({"token": token})
    }
