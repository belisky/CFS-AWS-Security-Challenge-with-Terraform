output "frontend_dns" {
  value = aws_lb.frontend_lb
}
output "backend_dns" {
  value = aws_lb.backend_lb
}