import json
import jwt
import os

SECRET_KEY = os.getenv('JWT_SECRET', 'supersecretkey')

def lambda_handler(event, context):
    # Récupération du token dans les headers
    auth_header = event.get("headers", {}).get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        return {
            "statusCode": 401,
            "body": json.dumps({"error": "No token provided"})
        }

    token = auth_header.split(" ")[1]

    try:
        # Vérifie si le token est valide
        jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    except jwt.ExpiredSignatureError:
        return {
            "statusCode": 401,
            "body": json.dumps({"error": "Token expired"})
        }
    except jwt.InvalidTokenError:
        return {
            "statusCode": 401,
            "body": json.dumps({"error": "Invalid token"})
        }

    # Ici on pourrait ajouter de la logique côté back pour invalider le token si tu veux (ex: blacklist)
    # Pour l'instant, la vraie "déconnexion" est côté front

    return {
        "statusCode": 200,
        "body": json.dumps({"message": "Logged out successfully"})
    }
