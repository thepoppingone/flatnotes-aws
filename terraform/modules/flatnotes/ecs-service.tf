# Create an ECS Service
resource "aws_ecs_service" "flatnotes" {
  count = var.deploy == true ? 1 : 0

  name            = "flatnotes-service"
  cluster         = aws_ecs_cluster.flatnotes_cluster.id
  task_definition = aws_ecs_task_definition.flatnotes.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.public_subnets_ids
    security_groups  = [aws_security_group.flatnotes.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.flatnotes[0].arn
    container_name   = "flatnotes"
    container_port   = 8080
  }
  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_policy]
}


# Create an Application Load Balancer
resource "aws_lb" "flatnotes" {
  count = var.deploy == true ? 1 : 0

  name               = "flatnotes-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.flatnotes.id]
  subnets            = var.public_subnets_ids

  enable_deletion_protection = false
}

# Create a Target Group
resource "aws_lb_target_group" "flatnotes" {
  count = var.deploy == true ? 1 : 0

  name        = "flatnotes-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# Create a Listener
resource "aws_lb_listener" "flatnotes" {
  count = var.deploy == true ? 1 : 0

  load_balancer_arn = aws_lb.flatnotes[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flatnotes[0].arn
  }
}

output "alb_dns" {
  value = try(aws_lb.flatnotes[0].dns_name, "no ALB deployed yet")
}

