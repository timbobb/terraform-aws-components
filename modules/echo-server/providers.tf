provider "aws" {
  region = var.region

  profile = module.iam_roles.profiles_enabled ? coalesce(var.import_profile_name, module.iam_roles.terraform_profile_name) : null
  dynamic "assume_role" {
    for_each = module.iam_roles.profiles_enabled ? [] : ["role"]
    content {
      role_arn = coalesce(var.import_role_arn, module.iam_roles.terraform_role_arn)
    }
  }
}

module "iam_roles" {
  source  = "../account-map/modules/iam-roles"
  context = module.this.context
}

variable "import_profile_name" {
  type        = string
  default     = null
  description = "AWS Profile name to use when importing a resource"
}

variable "import_role_arn" {
  type        = string
  default     = null
  description = "IAM Role ARN to use when importing a resource"
}

data "aws_eks_cluster" "kubernetes" {
  count = local.enabled ? 1 : 0

  name = module.eks.outputs.eks_cluster_id
}

data "aws_eks_cluster_auth" "kubernetes" {
  count = local.enabled ? 1 : 0

  name = module.eks.outputs.eks_cluster_id
}

provider "helm" {
  kubernetes {
    host                   = local.enabled ? data.aws_eks_cluster.kubernetes[0].endpoint : null
    token                  = local.enabled ? data.aws_eks_cluster_auth.kubernetes[0].token : null
    cluster_ca_certificate = local.enabled ? base64decode(data.aws_eks_cluster.kubernetes[0].certificate_authority[0].data) : null
  }
  experiments {
    manifest = true
  }
}
