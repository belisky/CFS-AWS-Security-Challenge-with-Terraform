output "frontend_dns" {
  value = aws_lb.frontend_lb
}
output "cloudfront_dns" {
  value = aws_cloudfront_distribution.cdn
}
