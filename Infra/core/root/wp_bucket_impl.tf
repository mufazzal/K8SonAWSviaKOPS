module "wp_bucket" {
  source = "../WorkSpaceBucket"
  wp_bucket_name = "${var.namePrefixSmallCase}${var.wp_bucket_name}"
}