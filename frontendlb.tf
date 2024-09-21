resource "aws_lb" "frontend_lb" {
  name               = "frontend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.frontendLB_sg.id]

  subnets = [
    aws_subnet.public_subnets.0.id,
    aws_subnet.public_subnets.1.id,
  ]
}

resource "aws_lb_target_group" "frontendTG" {
  name     = "frontendTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cloudforce_vpc.id

  health_check {
    enabled             = true
    port                = 80
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "frontendListener" {
  load_balancer_arn = aws_lb.frontend_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontendTG.arn
  }
}