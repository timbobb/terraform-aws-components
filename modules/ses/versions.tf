terraform {
  required_version = "~> 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.32"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
    utils = {
      source  = "cloudposse/utils"
      version = "~> 0.3"
    }
  }
}