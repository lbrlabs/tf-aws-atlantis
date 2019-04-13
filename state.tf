data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket = "lbr-production-lbrlabs-terraform-state"
    key    = "lbrlabs"
    region = "us-west-2"
    kms_key_id = "arn:aws:kms:us-west-2:609316800003:key/3cab9c55-c65a-405b-8c17-0e40f638be3f"
    encrypt = "true"
  }
}
