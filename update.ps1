# Chemin vers ton dossier Infrastructure
$baseDir = "C:\Users\AK\Documents\M2_MIAGE\Dev Cloud\Photo_Cloud_APM"

# Liste des Lambdas
$lambdas = @(
    "auth_signup",
    "auth_login",
    "auth_logout",
    "auth_refresh",
    "list_images",
    "create_upload",
    "confirm_upload",
    "get_image",
    "processor"
)

foreach ($lambda in $lambdas) {
    $srcFolder = Join-Path $baseDir "Lambdas\$lambda"
    $zipFile   = Join-Path $baseDir "Lambdas\$lambda.zip"

    if (Test-Path $zipFile) { Remove-Item $zipFile }

    Write-Host "Zipping $lambda..."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($srcFolder, $zipFile)
}

Write-Host "`nAll Lambdas zipped. Running OpenTofu apply..."
cd $baseDir\Infrastructure
tofu apply -auto-approve
