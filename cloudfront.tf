resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_lb.frontend_lb.dns_name
    origin_id   = "frontendweb"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
    custom_header {
      name="X-CDN-ID"
      value=var.custom_request_header_values
    }
   
  }
  

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  #   logging_config {
  #   include_cookies = false
  #   bucket          = "${aws_s3_bucket.cloudforce.id}.s3.amazonaws.com"
  #   prefix          = "CF-cloudfront"
  # }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontendweb"

    # forwarded_values {
    #   query_string = true
    #   cookies {
    #     forward = "all"
    #   }
    # }
    
    cache_policy_id = aws_cloudfront_cache_policy.custom_cache_policy.id
    origin_request_policy_id = var.managed_origin_request_policy_id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["GH"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [aws_lb.frontend_lb]
}
resource "aws_cloudfront_cache_policy" "custom_cache_policy" {
  name    = "custom-cache-policy"
  comment = "Cache policy for ALB-based frontend"

  default_ttl = 0  # 1 hour
  max_ttl     = 86400 # 24 hours
  min_ttl     = 0     # Minimum time to live

  parameters_in_cache_key_and_forwarded_to_origin {
    headers_config {
      header_behavior = "whitelist"

      # Cache behavior will depend on these headers
      headers {
        items = [
        "CloudFront-Viewer-Country",  # Cache by country
        "Accept-Language",            # Cache based on language preference
        "X-Forwarded-For", #can be added if needed, but not typically used for caching,
        "X-Forwarded-By",
        # "X-CDN-ID"
      ]
      }
    }

    cookies_config {
      cookie_behavior = "none"  # Not forwarding or caching based on cookies
    }

    query_strings_config {
      query_string_behavior = "none"  # Not caching based on query strings
    }
  }
}

# resource "aws_cloudfront_origin_request_policy" "custom_origin_request_policy" {
#   name = "custom-origin-request-policy"

  

#   headers_config {
#     header_behavior = "whitelist"

#     headers {
#       items=["X-CDN-ID"]    # Forward the X-Forwarded-For header (Client's IP address)# Optionally forward this if needed
#     }
#   }

#   cookies_config {
#     cookie_behavior = "none"  # No cookies are forwarded
#   }

#   query_strings_config {
#     query_string_behavior = "none"  # No query strings are forwarded
#   }
# }