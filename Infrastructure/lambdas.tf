resource "aws_lambda_function" "auth_signup" {
  function_name = "auth_signup"
  runtime       = "python3.10"
  handler       = "auth_signup.handler"
  role          = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/../lambdas/auth_signup.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/auth_signup.zip")
}

resource "aws_lambda_function" "auth_login" {
  function_name = "auth_login"
  runtime       = "python3.10"
  handler       = "auth_login.handler"
  role          = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/../lambdas/auth_login.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/auth_login.zip")
}

resource "aws_lambda_function" "auth_logout" {
  function_name = "auth_logout"
  runtime       = "python3.10"
  handler       = "auth_logout.handler"
  role          = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/../lambdas/auth_logout.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/auth_logout.zip")
}

resource "aws_lambda_function" "auth_refresh" {
  function_name = "auth_refresh"
  runtime       = "python3.10"
  handler       = "auth_refresh.handler"
  role          = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/../lambdas/auth_refresh.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/auth_refresh.zip")
}

resource "aws_lambda_function" "create_upload" {
  function_name = "create_upload"
  runtime       = "python3.10"
  handler       = "create_upload.handler"
  role          = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/../lambdas/create_upload.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/create_upload.zip")
}

resource "aws_lambda_function" "confirm_upload" {
  function_name = "confirm_upload"
  runtime       = "python3.10"
  handler       = "confirm_upload.handler"
  role          = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/../lambdas/confirm_upload.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/confirm_upload.zip")
}

resource "aws_lambda_function" "list_images" {
  function_name = "list_images"
  runtime       = "python3.10"
  handler       = "list_images.handler"
  role          = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/../lambdas/list_images.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/list_images.zip")
}

resource "aws_lambda_function" "get_image" {
  function_name = "get_image"
  runtime       = "python3.10"
  handler       = "get_image.handler"
  role          = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/../lambdas/get_image.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/get_image.zip")
}

resource "aws_lambda_function" "processor" {
  function_name = "processor"
  runtime       = "python3.10"
  handler       = "processor.handler"
  role          = aws_iam_role.lambda_role.arn
  filename         = "${path.module}/../lambdas/processor.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/processor.zip")
}
