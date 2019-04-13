resource "aws_ssm_parameter" "atlantis_github_user_token" {
  count = "${var.atlantis_github_user_token != "" ? 1 : 0}"

  name  = "${var.atlantis_github_user_token_ssm_parameter_name}"
  type  = "SecureString"
  value = "${var.atlantis_github_user_token}"
}
