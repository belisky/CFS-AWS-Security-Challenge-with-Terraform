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
   
  }
  

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontendweb"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    origin_request_policy_id = aws_cloudfront_origin_request_policy.custom_origin_request_policy.id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [aws_lb.frontend_lb]
}

resource "aws_cloudfront_origin_request_policy" "custom_origin_request_policy" {
  name = "custom-origin-request-policy"

  headers_config {
    header_behavior = "whitelist"

    headers {
      items=["X-Forwarded-For","X-Forwarded-By"]    # Forward the X-Forwarded-For header (Client's IP address)# Optionally forward this if needed
    }
  }

  cookies_config {
    cookie_behavior = "none"  # No cookies are forwarded
  }

  query_strings_config {
    query_string_behavior = "none"  # No query strings are forwarded
  }
}