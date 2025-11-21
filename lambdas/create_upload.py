import json
import boto3
import os
import jwt
import uuid
from datetime import datetime

SECRET_KEY = os.getenv('JWT_SECRET', 'supersecretkey')
s3 = boto3.client('s3', endpoint_url=os.getenv('S3_ENDPOINT'))
bucket_name = os.getenv('S3_BUCKET')
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
    filename = body.get("filename")
    if not filename:
        return {"statusCode": 400, "body": json.dumps({"error": "Filename required"})}
    
    image_id = str(uuid.uuid4())
    key = f"{payload['username']}/{image_id}_{filename}"
    
    # URL pré-signé S3
    url = s3.generate_presigned_url(
        'put_object',
        Params={'Bucket': bucket_name, 'Key': key},
        ExpiresIn=3600
    )
    
    # Stocker en attente confirmation
    table.put_item(Item={
        "image_id": image_id,
        "username": payload["username"],
        "key": key,
        "status": "pending",
        "uploaded_at": str(datetime.utcnow())
    })
    
    return {"statusCode": 200, "body": json.dumps({"upload_url": url, "image_id": image_id})}
