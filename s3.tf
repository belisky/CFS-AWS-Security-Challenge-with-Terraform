resource "aws_s3_bucket" "cloudforce" {
  bucket        = var.cloudforce_trail
  force_destroy = true
   
}
resource "aws_s3_bucket_ownership_controls" "restrict" {
  bucket = aws_s3_bucket.cloudforce.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "restrict" {
  depends_on = [aws_s3_bucket_ownership_controls.restrict]

  bucket = aws_s3_bucket.cloudforce.id
  acl    = "private"
}
 
resource "aws_s3_bucket_policy" "cloudforce_policy" {
  bucket = aws_s3_bucket.cloudforce.id
  policy = data.aws_iam_policy_document.CF_policy-cloudtrail.json
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

