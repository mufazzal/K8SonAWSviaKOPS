module "scripS3ObjectsImpl" {
  source = "../scripS3Objects"
  wp_bucket = module.wp_bucket.bucket_id
}



