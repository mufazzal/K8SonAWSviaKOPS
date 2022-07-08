data "terraform_remote_state" "stateMap" {
  for_each = var.dependencyStacks

  backend = "s3"
  config = {
    region = "${local.gv.region}"
    bucket = "${local.gv.stateFileBucket}"
    key = "${local.gv.stateFileCommonPrefix}${each.value}.tfstate"
    # TODO remove .tfstate hard coding
  }
}

data "aws_ssm_parameter" "globaVariables" {
  name = var.ssmParamNameOfGV #"/dev/globaVariables"
}

locals {
  gv = jsondecode(data.aws_ssm_parameter.globaVariables.value)
}

#  module.remoteStates.stateMap.network.outputs.vpc_id

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