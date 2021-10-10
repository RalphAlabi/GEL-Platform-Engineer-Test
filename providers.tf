provider "aws" {

  region = "eu-west-1"

  # assume_role {
  #   role_arn = "arn:aws:iam::564763253135:role/infra-deployer"
  # }
}

provider "archive" {}
