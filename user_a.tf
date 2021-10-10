resource "aws_iam_user" "user_a" {
  name = "USER-A"
}

data "aws_iam_policy_document" "read_and_write" {

  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = [aws_s3_bucket.source.arn]
  }

}

resource "aws_iam_user_policy" "bucket_a_permission" {
  name   = "Read-and-Write-access-to-Bucket-A"
  user   = aws_iam_user.user_a.name
  policy = data.aws_iam_policy_document.read_and_write.json
}