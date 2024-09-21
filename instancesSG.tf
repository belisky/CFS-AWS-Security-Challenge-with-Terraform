#Security group setup for frontend instances
resource "aws_security_group" "frontend_sg" {
  name = "frontend_instance_sg"
  ingress {
    from_port       = 0
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.frontendLB_sg.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.frontendLB_sg.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }


  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"    
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.frontendLB_sg.id]
    cidr_blocks     = ["0.0.0.0/0"]

  }
  vpc_id = aws_vpc.cloudforce_vpc.id

}

# security group for the backend instances
resource "aws_security_group" "backend_sg" {
  name = "backend_instances_sg"
  ingress {
    from_port       = 0
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.backendLB_sg.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.backendLB_sg.id]
    cidr_blocks     = ["0.0.0.0/0"]
  }


  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"    
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.backendLB_sg.id]
    cidr_blocks     = ["0.0.0.0/0"]

  }
  vpc_id = aws_vpc.cloudforce_vpc.id

}