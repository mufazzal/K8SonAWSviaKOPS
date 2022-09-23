module "WorkSpaceBucket" {

  source = "../../../Modules/Bucket"
  bucket_name = var.wp_bucket_name
}