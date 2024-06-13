terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.53"
    }
  }

  # backend "s3" {
  #   bucket = "name"
  #   key    = "key"
  #   region = "region"
  # }

}
