locals {
  vpc_id = "${data.terraform_remote_state.s3.vpc_id}"
  private_subnets = "${data.terraform_remote_state.s3.private_subnets}"
  public_subnets = "${data.terraform_remote_state.s3.public_subnets}"
  private_subnets_array = "${values(local.private_subnets)}"
  public_subnets_array = "${values(local.public_subnets)}"
  tags = "${merge(map("Name", var.name), var.tags)}"
}

output "private_subnets" {
  value = "${values(local.private_subnets)}"
}
