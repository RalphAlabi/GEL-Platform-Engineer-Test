data "aws_iam_policy_document" "trust_policy" {

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"

  }

}

resource "aws_iam_role" "extract_exif_lambda" {

  name               = "extract-exif-role"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}