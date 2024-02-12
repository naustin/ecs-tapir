# ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
  statement {
    sid    = "S3Access"
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.tapir.arn}/*",
      aws_s3_bucket.tapir.arn
    ]
    actions = [
      "s3:Describe*",
      "s3:List*",
      "s3:Get*",
      "s3:Put*"
    ]
  }
  statement {
    sid    = "DynamoDbAccess"
    effect = "Allow"
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/Modules",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/Providers",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/Reports",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/DeployKeys"
    ]
    actions = [
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:CreateTable",
      "dynamodb:DescribeTable",
      "dynamodb:GetItem"
    ]
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "osit-tapir"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



