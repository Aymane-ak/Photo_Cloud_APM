import json
import boto3
import hashlib
import os
import uuid
from datetime import datetime
from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError

# DynamoDB
dynamodb = boto3.resource('dynamodb', endpoint_url=os.getenv('DYNAMODB_ENDPOINT'))
table = dynamodb.Table(os.getenv('USERS_TABLE'))

def lambda_handler(event, context):
    # Récupérer le body
    try:
        body = json.loads(event.get("body", "{}"))
    except Exception:
        return {"statusCode": 400, "body": json.dumps({"error": "Invalid JSON"})}

    email = body.get("email")
    password = body.get("password")

    if not email or not password:
        return {"statusCode": 400, "body": json.dumps({"error": "Email and password required"})}

    # Vérifier si l'email existe déjà
    response = table.query(
        IndexName="email-index",
        KeyConditionExpression=Key("email").eq(email)
    )
    if response.get("Items"):
        return {"statusCode": 409, "body": json.dumps({"error": "User already exists"})}

    # Créer le nouvel utilisateur
    user_id = str(uuid.uuid4())
    password_hash = hashlib.sha256(password.encode()).hexdigest()

    try:
        table.put_item(
            Item={
                "userId": user_id,
                "email": email,
                "password_hash": password_hash,
                "role": "user",
                "created_at": datetime.utcnow().isoformat()
            },
            ConditionExpression="attribute_not_exists(email)"  # sécurité supplémentaire
        )
    except ClientError as e:
        if e.response['Error']['Code'] == 'ConditionalCheckFailedException':
            return {"statusCode": 409, "body": json.dumps({"error": "User already exists"})}
        else:
            return {"statusCode": 500, "body": json.dumps({"error": "Internal server error"})}

    return {"statusCode": 201, "body": json.dumps({"message": "User created", "userId": user_id})}
