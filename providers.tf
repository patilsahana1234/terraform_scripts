terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider for ap-southeast-2 (Default VPC)
provider "aws" {
  alias  = "sydney"
  region = "ap-southeast-2"
}

# Provider for ca-central-1 (Custom VPC)
provider "aws" {
  alias  = "canada"
  region = "ca-central-1"
}
