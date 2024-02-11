resource "aws_s3_bucket" "tapir" {
  bucket = "tf-registry"

  tags = {
    Name        = "tapir storage"
    Environment = "Dev"
  }
}
