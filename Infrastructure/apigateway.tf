#############################
# API Gateway REST pour Photo Cloud (v1)
#############################

# API principale
resource "aws_api_gateway_rest_api" "photo_cloud_api" {
  name        = "photo-cloud-api"
  description = "API REST pour Photo Cloud"
}

# Ressources de l'API
resource "aws_api_gateway_resource" "signup" {
  rest_api_id = aws_api_gateway_rest_api.photo_cloud_api.id
  parent_id   = aws_api_gateway_rest_api.photo_cloud_api.root_resource_id
  path_part   = "signup"
}

resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.photo_cloud_api.id
  parent_id   = aws_api_gateway_rest_api.photo_cloud_api.root_resource_id
  path_part   = "login"
}

resource "aws_api_gateway_resource" "logout" {
  rest_api_id = aws_api_gateway_rest_api.photo_cloud_api.id
  parent_id   = aws_api_gateway_rest_api.photo_cloud_api.root_resource_id
  path_part   = "logout"
}

resource "aws_api_gateway_resource" "refresh" {
  rest_api_id = aws_api_gateway_rest_api.photo_cloud_api.id
  parent_id   = aws_api_gateway_rest_api.photo_cloud_api.root_resource_id
  path_part   = "refresh"
}

resource "aws_api_gateway_resource" "images" {
  rest_api_id = aws_api_gateway_rest_api.photo_cloud_api.id
  parent_id   = aws_api_gateway_rest_api.photo_cloud_api.root_resource_id
  path_part   = "images"
}

resource "aws_api_gateway_resource" "image_id" {
  rest_api_id = aws_api_gateway_rest_api.photo_cloud_api.id
  parent_id   = aws_api_gateway_resource.images.id
  path_part   = "{image_id}"
}

resource "aws_api_gateway_resource" "confirm" {
  rest_api_id = aws_api_gateway_rest_api.photo_cloud_api.id
  parent_id   = aws_api_gateway_resource.images.id
  path_part   = "confirm"
}

#############################
# Méthodes HTTP
#############################

# POST /signup
resource "aws_api_gateway_method" "signup_post" {
  rest_api_id   = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id   = aws_api_gateway_resource.signup.id
  http_method   = "POST"
  authorization = "NONE"
}

# POST /login
resource "aws_api_gateway_method" "login_post" {
  rest_api_id   = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id   = aws_api_gateway_resource.login.id
  http_method   = "POST"
  authorization = "NONE"
}

# POST /logout
resource "aws_api_gateway_method" "logout_post" {
  rest_api_id   = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id   = aws_api_gateway_resource.logout.id
  http_method   = "POST"
  authorization = "NONE"
}

# POST /refresh
resource "aws_api_gateway_method" "refresh_post" {
  rest_api_id   = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id   = aws_api_gateway_resource.refresh.id
  http_method   = "POST"
  authorization = "NONE"
}

# GET /images
resource "aws_api_gateway_method" "list_images_get" {
  rest_api_id   = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id   = aws_api_gateway_resource.images.id
  http_method   = "GET"
  authorization = "NONE"
}

# POST /images
resource "aws_api_gateway_method" "create_upload_post" {
  rest_api_id   = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id   = aws_api_gateway_resource.images.id
  http_method   = "POST"
  authorization = "NONE"
}

# POST /images/confirm
resource "aws_api_gateway_method" "confirm_upload_post" {
  rest_api_id   = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id   = aws_api_gateway_resource.confirm.id
  http_method   = "POST"
  authorization = "NONE"
}

# GET /images/{image_id}
resource "aws_api_gateway_method" "get_image_get" {
  rest_api_id   = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id   = aws_api_gateway_resource.image_id.id
  http_method   = "GET"
  authorization = "NONE"
}

# DELETE /images/{image_id}
resource "aws_api_gateway_method" "delete_image_delete" {
  rest_api_id   = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id   = aws_api_gateway_resource.image_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

# PATCH /images/{image_id}
resource "aws_api_gateway_method" "update_image_patch" {
  rest_api_id   = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id   = aws_api_gateway_resource.image_id.id
  http_method   = "PATCH"
  authorization = "NONE"
}

#############################
# Intégrations Lambda
#############################

resource "aws_api_gateway_integration" "signup_integration" {
  rest_api_id             = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id             = aws_api_gateway_resource.signup.id
  http_method             = aws_api_gateway_method.signup_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.auth_signup.invoke_arn
}

resource "aws_api_gateway_integration" "login_integration" {
  rest_api_id             = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id             = aws_api_gateway_resource.login.id
  http_method             = aws_api_gateway_method.login_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.auth_login.invoke_arn
}

resource "aws_api_gateway_integration" "logout_integration" {
  rest_api_id             = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id             = aws_api_gateway_resource.logout.id
  http_method             = aws_api_gateway_method.logout_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.auth_logout.invoke_arn
}

resource "aws_api_gateway_integration" "refresh_integration" {
  rest_api_id             = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id             = aws_api_gateway_resource.refresh.id
  http_method             = aws_api_gateway_method.refresh_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.auth_refresh.invoke_arn
}

resource "aws_api_gateway_integration" "list_images_integration" {
  rest_api_id             = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id             = aws_api_gateway_resource.images.id
  http_method             = aws_api_gateway_method.list_images_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.list_images.invoke_arn
}

resource "aws_api_gateway_integration" "create_upload_integration" {
  rest_api_id             = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id             = aws_api_gateway_resource.images.id
  http_method             = aws_api_gateway_method.create_upload_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_upload.invoke_arn
}

resource "aws_api_gateway_integration" "confirm_upload_integration" {
  rest_api_id             = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id             = aws_api_gateway_resource.confirm.id
  http_method             = aws_api_gateway_method.confirm_upload_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.confirm_upload.invoke_arn
}

resource "aws_api_gateway_integration" "get_image_integration" {
  rest_api_id             = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id             = aws_api_gateway_resource.image_id.id
  http_method             = aws_api_gateway_method.get_image_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_image.invoke_arn
}

resource "aws_api_gateway_integration" "delete_image_integration" {
  rest_api_id             = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id             = aws_api_gateway_resource.image_id.id
  http_method             = aws_api_gateway_method.delete_image_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.processor.invoke_arn
}

resource "aws_api_gateway_integration" "update_image_integration" {
  rest_api_id             = aws_api_gateway_rest_api.photo_cloud_api.id
  resource_id             = aws_api_gateway_resource.image_id.id
  http_method             = aws_api_gateway_method.update_image_patch.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.processor.invoke_arn
}

#############################
# Permissions Lambda
#############################

resource "aws_lambda_permission" "allow_api_gateway_invoke" {
  for_each      = {
    auth_signup      = aws_lambda_function.auth_signup.function_name
    auth_login       = aws_lambda_function.auth_login.function_name
    auth_logout      = aws_lambda_function.auth_logout.function_name
    auth_refresh     = aws_lambda_function.auth_refresh.function_name
    list_images      = aws_lambda_function.list_images.function_name
    create_upload    = aws_lambda_function.create_upload.function_name
    confirm_upload   = aws_lambda_function.confirm_upload.function_name
    get_image        = aws_lambda_function.get_image.function_name
    delete_image     = aws_lambda_function.processor.function_name
    update_image     = aws_lambda_function.processor.function_name
  }
  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.photo_cloud_api.execution_arn}/*/*"
}
