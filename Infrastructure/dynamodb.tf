# -----------------------------
# USERS TABLE
# -----------------------------
resource "aws_dynamodb_table" "users" {
  name         = "users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
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

  # Optional for filtering by user
  attribute {
    name = "userId"
    type = "S"
  }

  global_secondary_index {
    name            = "userIdIndex"
    hash_key        = "userId"
    projection_type = "ALL"
  }
}
