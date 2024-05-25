resource "aws_s3_bucket" "mongodb_backups" {
  bucket = "${var.project_name}-mongodb-backups"
  acl    = "public-read"
}

output "bucket_name" {
  value = aws_s3_bucket.mongodb_backups.id
}
