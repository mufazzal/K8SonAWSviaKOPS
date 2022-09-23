module "sSMDocsImpl" {
  source = "../SSMDocs"
  namePrefix = var.namePrefix
  kops_state_bucket = var.kops_state_bucket
  kops_cluster_name = var.kops_cluster_name  
}