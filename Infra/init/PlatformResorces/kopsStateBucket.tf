module "KopsStateBucket" {

  source = "../../../Modules/kopsStateBucket"
  kops_state_bucket_name = var.kops_state_bucket_name
}