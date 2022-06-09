terraform {
  backend "s3" {
    bucket = "terraform-state-saude-tv-production"
    key    = "Prod/terraform.tfstate"
    region = "us-east-1"
  }
}
