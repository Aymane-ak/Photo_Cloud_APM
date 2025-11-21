resource "aws_s3_bucket" "raw_images" {
  bucket = "photo-cloud-raw"
}

resource "aws_s3_bucket" "thumbnails" {
  bucket = "photo-cloud-thumbnails"
}

# Désactiver le versioning / ACL legacy
resource "aws_s3_bucket_versioning" "raw_versioning" {
  bucket = aws_s3_bucket.raw_images.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_versioning" "thumbs_versioning" {
  bucket = aws_s3_bucket.thumbnails.id

  versioning_configuration {
    status = "Disabled"
  }
}
