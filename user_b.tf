resource "aws_iam_user" "user_b" {
  name = "USER-B"
}

data "aws_iam_policy_document" "read_only" {

  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*"
    ]
    effect    = "Allow"
    resources = [aws_s3_bucket.destination.arn]
  }

}

resource "aws_iam_user_policy" "bucket_b_permission" {
  name   = "Read-only-access-to-Bucket-B"
  user   = aws_iam_user.user_b.name
  policy = data.aws_iam_policy_document.read_only.json
}