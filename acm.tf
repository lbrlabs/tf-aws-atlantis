###################
# ACM (SSL certificate)
###################
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "v1.1.0"

  create_certificate = true

  domain_name = "${var.route53_zone_name}"
  zone_id     = "${data.aws_route53_zone.this.id}"

  subject_alternative_names = [
    "*.${var.route53_zone_name}",
  ]


  tags = "${local.tags}"
}
