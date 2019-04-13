module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "v1.1.0"

  name = "${var.name}"
}

locals {
  container_environment_variables = [
    {
      name  = "ATLANTIS_GH_USER"
      value = "${var.atlantis_github_user}"
    },
    {
      name  = "ATLANTIS_REPO_WHITELIST"
      value = "${join(",", var.atlantis_repo_whitelist)}"
    },
  ]

   container_definition_secrets_1 = [
    {
      name      = "ATLANTIS_GH_TOKEN"
      valueFrom = "${var.atlantis_github_user_token_ssm_parameter_name}"
    },
  ]

  container_definition_secrets_2 = [
    {
      name      = "ATLANTIS_GITLAB_WEBHOOK_SECRET"
      valueFrom = "${var.webhook_ssm_parameter_name}"
    },
  ]
}


module "container_definition_atlantis" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "v0.7.0"

  container_name  = "${var.name}"
  container_image = "runatlantis/atlantis:v0.7.1"

  container_cpu                = "${var.ecs_task_cpu}"
  container_memory             = "${var.ecs_task_memory}"
  container_memory_reservation = "${var.container_memory_reservation}"

  port_mappings = [
    {
      containerPort = "${var.atlantis_port}"
      hostPort      = "${var.atlantis_port}"
      protocol      = "tcp"
    },
  ]

  log_options = [
    {
      "awslogs-region"        = "${data.aws_region.current.name}"
      "awslogs-group"         = "${aws_cloudwatch_log_group.atlantis.name}"
      "awslogs-stream-prefix" = "ecs"
    },
  ]

  environment = "${local.container_environment_variables}"
  secrets     = [ "${local.container_definition_secrets_1}" ]

}



resource "aws_ecs_task_definition" "atlantis" {
  family                   = "${var.name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.ecs_task_cpu}"
  memory                   = "${var.ecs_task_memory}"
  execution_role_arn       = "${aws_iam_role.ecs_task_execution.arn}"
  task_role_arn            = "${aws_iam_role.ecs_task_execution.arn}"

  container_definitions    = "${module.container_definition_atlantis.json}"

}

data "aws_ecs_task_definition" "atlantis" {
  task_definition = "${var.name}"
  depends_on      = ["aws_ecs_task_definition.atlantis"]
}

resource "aws_ecs_service" "atlantis" {
  name                               = "${var.name}"
  cluster                            = "${module.ecs.this_ecs_cluster_id}"
  task_definition                    = "${data.aws_ecs_task_definition.atlantis.family}:${max(aws_ecs_task_definition.atlantis.revision, data.aws_ecs_task_definition.atlantis.revision)}"
  desired_count                      = "${var.ecs_service_desired_count}"
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = "${var.ecs_service_deployment_maximum_percent}"
  deployment_minimum_healthy_percent = "${var.ecs_service_deployment_minimum_healthy_percent}"

  network_configuration {
    subnets          = ["${values(local.private_subnets)}"]
    security_groups  = ["${module.atlantis_sg.this_security_group_id}"]
  }
  
  load_balancer {
    target_group_arn = "${aws_lb_target_group.main.id}"
    container_name   = "atlantis"
    container_port   = "${var.atlantis_port}"
  }

  depends_on = [
    "aws_lb_listener.main",
  ]

}
