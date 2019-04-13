module "alb_https_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "v2.11.0"

  name        = "${var.name}-alb-https"
  vpc_id      = "${local.vpc_id}"
  description = "Security group with HTTPS ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = "${var.alb_ingress_cidr_blocks}"

  tags = "${local.tags}"
}

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "v2.9.0"

  name        = "${var.name}-alb-http"
  vpc_id      = "${local.vpc_id}"
  description = "Security group with HTTP ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = "${var.alb_ingress_cidr_blocks}"

  tags = "${local.tags}"
}



module "atlantis_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v2.11.0"

  name        = "${var.name}"
  vpc_id      = "${local.vpc_id}"
  description = "Security group with open port for Atlantis (${var.atlantis_port}) from ALB, egress ports are all world open"

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = "${var.atlantis_port}"
      to_port                  = "${var.atlantis_port}"
      protocol                 = "tcp"
      description              = "Atlantis"
      source_security_group_id = "${module.alb_https_sg.this_security_group_id}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = "${local.tags}"
}
