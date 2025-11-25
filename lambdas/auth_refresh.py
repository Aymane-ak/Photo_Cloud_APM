import json
import jwt
import os
from datetime import datetime, timedelta

SECRET_KEY = os.getenv('JWT_SECRET', 'supersecretkey')

def lambda_handler(event, context):
    auth_header = event.get("headers", {}).get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        return {"statusCode": 401, "body": json.dumps({"error": "Missing token"})}
    
    token = auth_header.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    except jwt.ExpiredSignatureError:
        return {"statusCode": 401, "body": json.dumps({"error": "Token expired"})}
    except jwt.InvalidTokenError:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid token"})}
    
    # Générer un nouveau token
    new_payload = {
        "userId": payload["userId"],
        "email": payload["email"],
        "role": payload.get("role", "user"),
        "exp": datetime.utcnow() + timedelta(hours=1)
    }
    new_token = jwt.encode(new_payload, SECRET_KEY, algorithm="HS256")
    
    return {"statusCode": 200, "body": json.dumps({"token": new_token})}
