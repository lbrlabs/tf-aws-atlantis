data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_route53_zone" "this" {
  name         = "${var.route53_zone_name}"
  private_zone = false
}
