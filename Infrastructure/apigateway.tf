#############################
# API Gateway HTTP pour Photo Cloud
#############################

resource "aws_apigatewayv2_api" "photo_cloud_api" {
  name          = "photo-cloud-api"
  protocol_type = "HTTP"
}

#############################
# Intégrations Lambda
#############################

resource "aws_apigatewayv2_integration" "auth_signup" {
  api_id           = aws_apigatewayv2_api.photo_cloud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.auth_signup.arn
}

resource "aws_apigatewayv2_integration" "auth_login" {
  api_id           = aws_apigatewayv2_api.photo_cloud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.auth_login.arn
}

resource "aws_apigatewayv2_integration" "auth_logout" {
  api_id           = aws_apigatewayv2_api.photo_cloud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.auth_logout.arn
}

resource "aws_apigatewayv2_integration" "auth_refresh" {
  api_id           = aws_apigatewayv2_api.photo_cloud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.auth_refresh.arn
}

resource "aws_apigatewayv2_integration" "list_images" {
  api_id           = aws_apigatewayv2_api.photo_cloud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.list_images.arn
}

resource "aws_apigatewayv2_integration" "create_upload" {
  api_id           = aws_apigatewayv2_api.photo_cloud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.create_upload.arn
}

resource "aws_apigatewayv2_integration" "confirm_upload" {
  api_id           = aws_apigatewayv2_api.photo_cloud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.confirm_upload.arn
}

resource "aws_apigatewayv2_integration" "get_image" {
  api_id           = aws_apigatewayv2_api.photo_cloud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.get_image.arn
}

resource "aws_apigatewayv2_integration" "processor" {
  api_id           = aws_apigatewayv2_api.photo_cloud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.processor.arn
}

#############################
# Routes API Gateway
#############################

resource "aws_apigatewayv2_route" "signup" {
  api_id    = aws_apigatewayv2_api.photo_cloud_api.id
  route_key = "POST /signup"
  target    = "integrations/${aws_apigatewayv2_integration.auth_signup.id}"
}

resource "aws_apigatewayv2_route" "login" {
  api_id    = aws_apigatewayv2_api.photo_cloud_api.id
  route_key = "POST /login"
  target    = "integrations/${aws_apigatewayv2_integration.auth_login.id}"
}

resource "aws_apigatewayv2_route" "logout" {
  api_id    = aws_apigatewayv2_api.photo_cloud_api.id
  route_key = "POST /logout"
  target    = "integrations/${aws_apigatewayv2_integration.auth_logout.id}"
}

resource "aws_apigatewayv2_route" "refresh" {
  api_id    = aws_apigatewayv2_api.photo_cloud_api.id
  route_key = "POST /refresh"
  target    = "integrations/${aws_apigatewayv2_integration.auth_refresh.id}"
}

resource "aws_apigatewayv2_route" "list_images" {
  api_id    = aws_apigatewayv2_api.photo_cloud_api.id
  route_key = "GET /images"
  target    = "integrations/${aws_apigatewayv2_integration.list_images.id}"
}

resource "aws_apigatewayv2_route" "create_upload" {
  api_id    = aws_apigatewayv2_api.photo_cloud_api.id
  route_key = "POST /images"
  target    = "integrations/${aws_apigatewayv2_integration.create_upload.id}"
}

resource "aws_apigatewayv2_route" "confirm_upload" {
  api_id    = aws_apigatewayv2_api.photo_cloud_api.id
  route_key = "POST /images/confirm"
  target    = "integrations/${aws_apigatewayv2_integration.confirm_upload.id}"
}

resource "aws_apigatewayv2_route" "get_image" {
  api_id    = aws_apigatewayv2_api.photo_cloud_api.id
  route_key = "GET /images/{image_id}"
  target    = "integrations/${aws_apigatewayv2_integration.get_image.id}"
}

resource "aws_apigatewayv2_route" "delete_image" {
  api_id    = aws_apigatewayv2_api.photo_cloud_api.id
  route_key = "DELETE /images/{image_id}"
  target    = "integrations/${aws_apigatewayv2_integration.processor.id}"
}

resource "aws_apigatewayv2_route" "update_image" {
  api_id    = aws_apigatewayv2_api.photo_cloud_api.id
  route_key = "PATCH /images/{image_id}"
  target    = "integrations/${aws_apigatewayv2_integration.processor.id}"
}

#############################
# Permissions Lambda
#############################

# Permettre à API Gateway d'invoquer chaque Lambda
resource "aws_lambda_permission" "allow_api_gateway_auth_signup" {
  statement_id  = "AllowAPIGatewayInvokeAuthSignup"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_signup.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.photo_cloud_api.execution_arn}/*/*"
}

# Répéter pour chaque Lambda
resource "aws_lambda_permission" "allow_api_gateway_auth_login" {
  statement_id  = "AllowAPIGatewayInvokeAuthLogin"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_login.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.photo_cloud_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_auth_logout" {
  statement_id  = "AllowAPIGatewayInvokeAuthLogout"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_logout.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.photo_cloud_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_auth_refresh" {
  statement_id  = "AllowAPIGatewayInvokeAuthRefresh"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_refresh.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.photo_cloud_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_list_images" {
  statement_id  = "AllowAPIGatewayInvokeListImages"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_images.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.photo_cloud_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_create_upload" {
  statement_id  = "AllowAPIGatewayInvokeCreateUpload"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_upload.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.photo_cloud_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_confirm_upload" {
  statement_id  = "AllowAPIGatewayInvokeConfirmUpload"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.confirm_upload.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.photo_cloud_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_get_image" {
  statement_id  = "AllowAPIGatewayInvokeGetImage"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_image.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.photo_cloud_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_processor" {
  statement_id  = "AllowAPIGatewayInvokeProcessor"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.photo_cloud_api.execution_arn}/*/*"
}
