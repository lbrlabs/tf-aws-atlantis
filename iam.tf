resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.name}-ecs_task_execution"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  count = "${length(var.policies_arn)}"

  role       = "${aws_iam_role.ecs_task_execution.id}"
  policy_arn = "${element(var.policies_arn, count.index)}"
}

data "aws_iam_policy_document" "ecs_task_access_secrets" {
  statement {
    effect = "Allow"

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${var.webhook_ssm_parameter_name}",
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${var.atlantis_github_user_token_ssm_parameter_name}",
    ]

    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
    ]
  }
}

data "aws_iam_policy_document" "ecs_task_access_secrets_with_kms" {
  source_json = "${data.aws_iam_policy_document.ecs_task_access_secrets.0.json}"

  statement {
    sid       = "AllowKMSDecrypt"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = [ "*" ]
  }
}

resource "aws_iam_role_policy" "ecs_task_access_secrets" {

  name = "ECSTaskAccessSecretsPolicy"

  role = "${aws_iam_role.ecs_task_execution.id}"

  policy = "${element(compact(concat(data.aws_iam_policy_document.ecs_task_access_secrets_with_kms.*.json, data.aws_iam_policy_document.ecs_task_access_secrets.*.json)), 0)}"
}
