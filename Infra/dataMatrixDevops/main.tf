module "dataMatrixDev" {
  source = "../../Modules/dataMatrixInterface"
  dependencyStacks = var.dependencyStacks

  # region = self.local.gv.region
  # stateFileBucket = self.local.gv.stateFileBucket
  # stateFileCommonPrefix = self.local.gv.stateFileCommonPrefix
  ssmParamNameOfGV = local.ssmParamNameOfGV
  # config = {
  #   region = local.gv.region
  #   bucket = local.gv.stateBucket
  #   key = "${local.gv.stateFilePrefix}${stackToStateFileMap}[${each.value}]"
  # }
}

locals {
  ssmParamNameOfGV  = "/devops/k8s/globaVariables"
}

# google_storage_bucket.map["bucket_1"]


# locals {
#   bucket_settings = {
#     "network"  = { stateFilePrefix: "asdas", stateFileName = "network.tfstate", stateFilePrefix = "as" }
#   }
# }

# resource "google_storage_bucket" "map" {
#   for_each      = local.bucket_settings

#   name               = each.key
#   location           = each.value.location
#   storage_class      = "REGIONAL"
#   bucket_policy_only = each.value.bucket_policy_only
# }


# your_elb = "${terraform_remote_state.your_state.output.your_output_resource}"