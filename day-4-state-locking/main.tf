resource "aws_vpc" "name" {
    cidr_block = var.vpc_id
    tags = {
      Name = "pro"
    }
}

resource "aws_s3_bucket" "name" {
  bucket = "ttttttttttttttp"
  tags = {
    Name = "MyBucket"
  } 
}
