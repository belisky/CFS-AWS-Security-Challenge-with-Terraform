resource "aws_cloudtrail" "cloudforce_trail" {
  depends_on = [aws_s3_bucket_policy.cloudforce_policy]
  

  name                          = "force_trail"
  s3_bucket_name                = aws_s3_bucket.cloudforce.id
  s3_key_prefix                 = var.environment_name
  include_global_service_events = false
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

   # Allow CloudFront to write access logs to the bucket
  statement {
    sid    = "AWSCloudFrontWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudforce.arn}/${var.environment_name}/cloudfront-logs/${data.aws_caller_identity.current.account_id}/*"]

    # condition {
    #   test     = "StringEquals"
    #   variable = "s3:x-amz-acl"
    #   values   = ["bucket-owner-full-control"]
    # }
  }
}



 