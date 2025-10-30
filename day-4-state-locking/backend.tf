terraform {
  backend "s3" {
    bucket = "ttttttttttttttp"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}