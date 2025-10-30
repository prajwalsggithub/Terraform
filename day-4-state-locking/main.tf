resource "aws_vpc" "name" {
    cidr_block = var.vpc_id
    tags = {
      Name = "MyVPC"
    }
}

resource "aws_s3_bucket" "name" {
  bucket = "ttttttttttttttp"
  tags = {
    Name = "MyBucket"
  } 
}
