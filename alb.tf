resource "aws_lb" "main" {
  name            = "${var.name}"
  subnets         = [ "${values(local.public_subnets)}" ]
  security_groups = ["${module.alb_https_sg.this_security_group_id}", "${module.alb_http_sg.this_security_group_id}"]
}

resource "aws_lb_target_group" "main" {
  name        = "${var.name}"
  port        = "${var.atlantis_port}"
  protocol    = "HTTP"
  vpc_id      = "${local.vpc_id}"
  target_type = "ip"
  depends_on  = [ "aws_lb.main" ]
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "main" {
  load_balancer_arn = "${aws_lb.main.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.main.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "main-tls" {
  load_balancer_arn = "${aws_lb.main.id}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${module.acm.this_acm_certificate_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.main.id}"
    type             = "forward"
  }
}


