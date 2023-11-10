terraform {
  # backend "s3" {
  #   bucket  = "terraform-state-file"
  #   key     = "terraform.tfstate"
  #   region  = "us-east-1"
  #   profile = "default"
  # }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}