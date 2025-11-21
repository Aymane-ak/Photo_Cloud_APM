import json
import boto3
import hashlib
import os

dynamodb = boto3.resource('dynamodb', endpoint_url=os.getenv('DYNAMODB_ENDPOINT'))
table = dynamodb.Table(os.getenv('USERS_TABLE'))

def lambda_handler(event, context):
    body = json.loads(event.get("body", "{}"))
    username = body.get("username")
    password = body.get("password")
    
    if not username or not password:
        return {"statusCode": 400, "body": json.dumps({"error": "Username and password required"})}
    
    # Hash du mot de passe
    password_hash = hashlib.sha256(password.encode()).hexdigest()
    
    # Créer l'utilisateur dans DynamoDB
    table.put_item(Item={
        "username": username,
        "password_hash": password_hash,
        "role": "user"  # par défaut
    })
    
    return {"statusCode": 201, "body": json.dumps({"message": "User created"})}
