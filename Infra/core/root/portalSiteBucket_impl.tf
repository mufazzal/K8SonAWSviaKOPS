module "portalSiteBucketImpl" {
  source = "../PortalSiteBucket"
  bucket_name = "${var.namePrefixSmallCase}${var.portal_site_bucket_name}"
}