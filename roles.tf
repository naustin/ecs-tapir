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
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = aws_iam_role.tapir.name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "tapir" {
  name               = "tapir"
  description        = "Role assumed by EKS ServiceAccount tapir"
  assume_role_policy = data.aws_iam_policy_document.tapir_sa.json
  tags = {
    "Resource" = "aws_iam_role.tapir"
  }
}

data "aws_iam_policy_document" "tapir_sa" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(local.eks_oidc_issuer_url, "https://", "")}"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(local.eks_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${kubernetes_namespace_v1.tapir.id}:${local.name}"]
    }
  }
}

resource "aws_iam_role_policy" "tapir" {
  name = "tapir"
  role   = aws_iam_role.tapir.id
  policy = data.aws_iam_policy_document.tapir.json
}

data "aws_iam_policy_document" "tapir" {
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