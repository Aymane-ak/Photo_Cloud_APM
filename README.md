/infrastructure
    providers.tf
    variables.tf
    outputs.tf
    s3.tf
    dynamodb.tf
    sqs.tf
    iam.tf
    lambdas.tf
    apigateway.tf
    /localstack
        docker-compose.yml

/lambdas
    auth_signup.py
    auth_login.py
    auth_refresh.py
    auth_logout.py
    create_upload.py
    confirm_upload.py
    list_images.py
    get_image.py
    processor.py

/frontend
    index.html
    app.js
    style.css


# Liste les tables
awslocal dynamodb list-tables

# Exemple : lister tous les users
awslocal dynamodb scan --table-name users

# Exemple : lister toutes les images
awslocal dynamodb scan --table-name images

tofu init
tofu plan
tofu apply




Compress-Archive -Path auth_login.py -DestinationPath auth_login.zip
Compress-Archive -Path auth_logout.py -DestinationPath auth_logout.zip
Compress-Archive -Path auth_refresh.py -DestinationPath auth_refresh.zip
Compress-Archive -Path auth_signup.py -DestinationPath auth_signup.zip
Compress-Archive -Path confirm_upload.py -DestinationPath confirm_upload.zip
Compress-Archive -Path create_upload.py -DestinationPath create_upload.zip
Compress-Archive -Path get_image.py -DestinationPath get_image.zip
Compress-Archive -Path list_images.py -DestinationPath list_images.zip
Compress-Archive -Path processor.py -DestinationPath processor.zip