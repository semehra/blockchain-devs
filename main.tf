terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}


resource "aws_lambda_function" "lambda_docs_function" {
  filename      = "README.md.zip"
  function_name = "lambda-function"
  role          = aws_iam_role.lambda_exec_iam_role.arn
  handler       = "get_export.lambda_handler"
  runtime       = "python3.8"

  environment {
    variables = {
      restApiId = "Rest api name"
      stageName = "api"
    }
  }
}

resource "aws_iam_role" "lambda_exec_iam_role" {
  name               = "lambda_function"
  assume_role_policy = file("./api/iam/lambda_role.json")
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "lambda_function"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = file("./api/iam/lambda_policy.json")
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_exec_iam_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}
