resource "aws_launch_template" "frontend" {
  name_prefix = "frontend"
  image_id = var.ami_id
  instance_type = var.instance_type
  network_interfaces {
    security_groups = [ "${aws_security_group.frontend_sg.id}" ]

    associate_public_ip_address = true
  }
  
  user_data = "${base64encode(file("frontenddata.sh"))}"
  lifecycle {
      create_before_destroy = true
    }
}