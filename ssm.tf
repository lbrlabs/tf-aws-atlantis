resource "random_id" "webhook" {
  byte_length = "64"
}


resource "aws_ssm_parameter" "atlantis_github_user_token" {
  count = "${var.atlantis_github_user_token != "" ? 1 : 0}"

  name  = "${var.atlantis_github_user_token_ssm_parameter_name}"
  type  = "SecureString"
  value = "${var.atlantis_github_user_token}"
}

resource "aws_ssm_parameter" "webhook" {

  name  = "${var.webhook_ssm_parameter_name}"
  type  = "SecureString"
  value = "${random_id.webhook.hex}"
}


