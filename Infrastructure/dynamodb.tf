# -----------------------------
# USERS TABLE
# -----------------------------
resource "aws_dynamodb_table" "users" {
  name         = "users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  # Attributs de la table
  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  # Index pour rechercher par email (pour login)
  global_secondary_index {
    name            = "email-index"
    hash_key        = "email"
    projection_type = "ALL"
  }
}

# -----------------------------
# IMAGES TABLE
# -----------------------------
resource "aws_dynamodb_table" "images" {
  name         = "images"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "imageId"

  attribute {
    name = "imageId"
    type = "S"
  }

  attribute {
    name = "userId"
    type = "S"
  }

  # Index pour récupérer toutes les images d'un utilisateur
  global_secondary_index {
    name            = "userId-index"
    hash_key        = "userId"
    projection_type = "ALL"
  }
}
