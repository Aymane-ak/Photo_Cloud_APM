import json
import boto3
import os
import jwt

SECRET_KEY = os.getenv("JWT_SECRET", "supersecretkey")
dynamodb = boto3.resource("dynamodb", endpoint_url=os.getenv("DYNAMODB_ENDPOINT"))
images_table = dynamodb.Table(os.getenv("IMAGES_TABLE"))

def lambda_handler(event, context):
    auth_header = event.get("headers", {}).get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        return {"statusCode": 401, "body": json.dumps({"error": "Missing token"})}

    token = auth_header.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    except jwt.InvalidTokenError:
        return {"statusCode": 401, "body": json.dumps({"error": "Invalid token"})}

    username = payload["username"]
    is_superadmin = payload.get("role") == "superadmin"
    
    image_id = event.get("pathParameters", {}).get("image_id")
    if not image_id:
        return {"statusCode": 400, "body": json.dumps({"error": "image_id required"})}

    response = images_table.get_item(Key={"image_id": image_id})
    item = response.get("Item")
    if not item:
        return {"statusCode": 404, "body": json.dumps({"error": "Image not found"})}
    
    if item["username"] != username and not is_superadmin:
        return {"statusCode": 403, "body": json.dumps({"error": "Forbidden"})}

    # Déterminer l'action : PATCH pour modification, DELETE pour suppression
    method = event.get("requestContext", {}).get("http", {}).get("method")
    if method == "DELETE":
        images_table.delete_item(Key={"image_id": image_id})
        return {"statusCode": 200, "body": json.dumps({"message": "Image deleted"})}

    if method == "PATCH":
        body = json.loads(event.get("body", "{}"))
        update_expr = []
        expr_attr_values = {}
        expr_attr_names = {}
        for k, v in body.items():
            update_expr.append(f"#{k} = :{k}")
            expr_attr_values[f":{k}"] = v
            expr_attr_names[f"#{k}"] = k
        if update_expr:
            images_table.update_item(
                Key={"image_id": image_id},
                UpdateExpression="SET " + ", ".join(update_expr),
                ExpressionAttributeNames=expr_attr_names,
                ExpressionAttributeValues=expr_attr_values
            )
        return {"statusCode": 200, "body": json.dumps({"message": "Image updated"})}

    return {"statusCode": 400, "body": json.dumps({"error": "Unsupported method"})}
