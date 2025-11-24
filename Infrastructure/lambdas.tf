##########################################
# LAMBDA FUNCTIONS
##########################################

# ---------------------------
# AUTH SIGNUP
# ---------------------------
resource "aws_lambda_function" "auth_signup" {
  function_name = "auth_signup"
  runtime       = "python3.10"
  handler       = "auth_signup.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambdas/auth_signup.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/auth_signup.zip")

  environment {
    variables = {
      USERS_TABLE       = aws_dynamodb_table.users.name
      DYNAMODB_ENDPOINT = "http://localhost:4566"
      JWT_SECRET        = "supersecretkey"
    }
  }
}

# ---------------------------
# AUTH LOGIN
# ---------------------------
resource "aws_lambda_function" "auth_login" {
  function_name = "auth_login"
  runtime       = "python3.10"
  handler       = "auth_login.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambdas/auth_login.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/auth_login.zip")

  environment {
    variables = {
      USERS_TABLE       = aws_dynamodb_table.users.name
      DYNAMODB_ENDPOINT = "http://localhost:4566"
      JWT_SECRET        = "supersecretkey"
    }
  }
}

# ---------------------------
# AUTH LOGOUT
# ---------------------------
resource "aws_lambda_function" "auth_logout" {
  function_name = "auth_logout"
  runtime       = "python3.10"
  handler       = "auth_logout.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambdas/auth_logout.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/auth_logout.zip")

  environment {
    variables = {
      JWT_SECRET = "supersecretkey"
    }
  }
}

# ---------------------------
# AUTH REFRESH
# ---------------------------
resource "aws_lambda_function" "auth_refresh" {
  function_name = "auth_refresh"
  runtime       = "python3.10"
  handler       = "auth_refresh.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambdas/auth_refresh.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/auth_refresh.zip")

  environment {
    variables = {
      JWT_SECRET        = "supersecretkey"
      USERS_TABLE       = aws_dynamodb_table.users.name
      DYNAMODB_ENDPOINT = "http://localhost:4566"
    }
  }
}

# ---------------------------
# CREATE UPLOAD
# ---------------------------
resource "aws_lambda_function" "create_upload" {
  function_name = "create_upload"
  runtime       = "python3.10"
  handler       = "create_upload.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambdas/create_upload.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/create_upload.zip")

  environment {
    variables = {
      IMAGES_TABLE      = aws_dynamodb_table.images.name
      DYNAMODB_ENDPOINT = "http://localhost:4566"
      S3_BUCKET         = aws_s3_bucket.raw_images.bucket
      S3_ENDPOINT       = "http://localhost:4566"
      JWT_SECRET        = "supersecretkey"
    }
  }
}

# ---------------------------
# CONFIRM UPLOAD
# ---------------------------
resource "aws_lambda_function" "confirm_upload" {
  function_name = "confirm_upload"
  runtime       = "python3.10"
  handler       = "confirm_upload.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambdas/confirm_upload.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/confirm_upload.zip")

  environment {
    variables = {
      IMAGES_TABLE      = aws_dynamodb_table.images.name
      DYNAMODB_ENDPOINT = "http://localhost:4566"
      JWT_SECRET        = "supersecretkey"
    }
  }
}

# ---------------------------
# LIST IMAGES
# ---------------------------
resource "aws_lambda_function" "list_images" {
  function_name = "list_images"
  runtime       = "python3.10"
  handler       = "list_images.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambdas/list_images.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/list_images.zip")

  environment {
    variables = {
      IMAGES_TABLE      = aws_dynamodb_table.images.name
      DYNAMODB_ENDPOINT = "http://localhost:4566"
      JWT_SECRET        = "supersecretkey"
    }
  }
}

# ---------------------------
# GET IMAGE
# ---------------------------
resource "aws_lambda_function" "get_image" {
  function_name = "get_image"
  runtime       = "python3.10"
  handler       = "get_image.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambdas/get_image.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/get_image.zip")

  environment {
    variables = {
      IMAGES_TABLE      = aws_dynamodb_table.images.name
      DYNAMODB_ENDPOINT = "http://localhost:4566"
      S3_BUCKET         = aws_s3_bucket.raw_images.bucket
      S3_ENDPOINT       = "http://localhost:4566"
      JWT_SECRET        = "supersecretkey"
    }
  }
}

# ---------------------------
# PROCESSOR (PATCH/DELETE)
# ---------------------------
resource "aws_lambda_function" "processor" {
  function_name = "processor"
  runtime       = "python3.10"
  handler       = "processor.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambdas/processor.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/processor.zip")

  environment {
    variables = {
      IMAGES_TABLE      = aws_dynamodb_table.images.name
      DYNAMODB_ENDPOINT = "http://localhost:4566"
      JWT_SECRET        = "supersecretkey"
    }
  }
}
