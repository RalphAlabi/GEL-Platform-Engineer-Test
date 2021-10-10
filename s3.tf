resource "aws_s3_bucket" "source" {
  bucket = "ralph-images-source-bucket-a"
  acl    = "public-read" #private

  versioning {
    enabled = true
  }

}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.source.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.exif_function.arn
    events              = ["s3:ObjectCreated:Put"]
    filter_prefix       = "jpg/"
  }

  depends_on = [aws_lambda_permission.allow_source_bucket]
}

resource "aws_s3_bucket" "destination" {
  bucket = "ralph-images-destination-bucket-b"
  acl    = "public-read" #private

  versioning {
    enabled = true
  }

}