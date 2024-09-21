resource "aws_launch_template" "backend" {
  name_prefix   = "backend"
  image_id      = var.ami_id
  instance_type = var.instance_type
  network_interfaces {
    security_groups = ["${aws_security_group.backend_sg.id}"]

    associate_public_ip_address = true
  }

  user_data = base64encode(file("backenddata.sh"))
  lifecycle {
    create_before_destroy = true
  }
}