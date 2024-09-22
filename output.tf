output "frontend_dns" {
  value = aws_lb.frontend_lb.dns_name
}
output "cloudfront_dns" {
  value = aws_cloudfront_distribution.cdn.domain_name
}
