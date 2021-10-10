data "archive_file" "exif_extractor" {
  type        = "zip"
  source_file = "${path.module}/extract_exif.py"
  output_path = "${path.module}/lambda_files/extract_exif.zip"
}

# resource "aws_cloudwatch_event_rule" "exif_event_rule" {
#   name                = "exif_event_rule"
#   description         = "Event rule to trigger extract-exif lambda function at a scheduled time"
#   schedule_expression = "0 22 * * *"
# }

# resource "aws_cloudwatch_event_target" "exif_rule_target" {
#   rule      = aws_cloudwatch_event_rule.exif_event_rule.name
#   target_id = "SendToLambda"
#   arn       = aws_lambda_function.exif_function.arn
# }

resource "aws_lambda_function" "exif_function" {

  function_name    = "extract-exif"
  description      = "Lambda function to extract EXIF metadata from all the images uploaded to s3 bucket"
  filename         = data.archive_file.exif_extractor.output_path
  runtime          = "python3.6"
  timeout          = 900
  memory_size      = "1024"
  role             = aws_iam_role.extract_exif_lambda.arn
  handler          = "extract_exif.extract_exif"
  source_code_hash = data.archive_file.exif_extractor.output_base64sha256

  environment {
    variables = {
      environment = "Test"
    }
  }

  depends_on = [aws_iam_role.extract_exif_lambda]
}

resource "aws_lambda_permission" "allow_source_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.exif_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source.arn
}