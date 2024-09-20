resource "aws_cloudtrail" "cloudforce_trail" {
  depends_on = [aws_s3_bucket_policy.cloudforce_policy]
  

  name                          = "force_trail"
  s3_bucket_name                = aws_s3_bucket.cloudforce.id
  s3_key_prefix                 = var.environment_name
  include_global_service_events = false
}

resource "aws_s3_bucket" "cloudforce" {
  bucket        = var.cloudforce_trail
  force_destroy = true
}
 
data "aws_iam_policy_document" "CF_policy-cloudtrail" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudforce.arn]
    
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudforce.arn}/${var.environment_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
 
  }
}

resource "aws_s3_bucket_policy" "cloudforce_policy" {
  bucket = aws_s3_bucket.cloudforce.id
  policy = data.aws_iam_policy_document.CF_policy-cloudtrail.json
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}
 

 