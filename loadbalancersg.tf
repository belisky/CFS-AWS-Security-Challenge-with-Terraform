#FrontendLB security group
resource "aws_security_group" "frontendLB_sg" {
  name = "frontendLB-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.cloudforce_vpc.id

}


#BackendLB security group
resource "aws_security_group" "backendLB_sg" {
  name = "backendLB-sg"
  ingress {
    from_port   = 0
    to_port     = 80
    security_groups = [aws_security_group.frontend_sg.id]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 

  egress {
    from_port   = 0
    to_port     = 0
    security_groups = [aws_security_group.backend_sg.id]
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.cloudforce_vpc.id

}