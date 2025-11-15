provider "aws" {
  alias  = "primary"
  region = "us-west-2"   # ✅ REGION, not AZ
}

provider "aws" {
  alias  = "replica"
  region = "us-east-1"   # ✅ REGION, not AZ
}
