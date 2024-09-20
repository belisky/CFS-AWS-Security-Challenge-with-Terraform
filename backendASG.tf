resource "aws_autoscaling_group" "backendASG" {
  name     = "backendASG"
  min_size = 2
  max_size = 6

  health_check_type = "EC2"

  vpc_zone_identifier = [
    aws_subnet.private_subnets.0.id,
    aws_subnet.private_subnets.1.id,

  ]

  target_group_arns = [aws_lb_target_group.backendTG.arn]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.backend.id
      }

    }
  }
}

resource "aws_autoscaling_policy" "asgpolicy2" {
  name                   = "asgpolicy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.backendASG.name

  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 25.0
  }
}