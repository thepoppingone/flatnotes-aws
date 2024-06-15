# resource "aws_ecs_task_definition" "flatnotes" {
#   family                   = "flatnotes"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256"
#   memory                   = "512"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

#   runtime_platform {
#     operating_system_family = "LINUX"
#     cpu_architecture        = "ARM64"
#   }

#   container_definitions = jsonencode([
#     {
#       name      = "flatnotes"
#       image     = "891377084300.dkr.ecr.ap-southeast-1.amazonaws.com/flatnotes:latest "
#       essential = true
#       portMappings = [
#         {
#           containerPort = 8080
#           hostPort      = 8080
#           protocol      = "tcp"
#         }
#       ]
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           "awslogs-group"         = aws_cloudwatch_log_group.flatnotes.name
#           "awslogs-region"        = "ap-southeast-1"
#           "awslogs-stream-prefix" = "ecs"
#         }
#       }
#       environment = [
#         {
#           name  = "PUID"
#           value = "1000"
#         },
#         {
#           name  = "PGID"
#           value = "1000"
#         },
#         {
#           name  = "FLATNOTES_AUTH_TYPE"
#           value = "password"
#         },
#         {
#           name  = "FLATNOTES_USERNAME"
#           value = var.flatnotes_username
#         },
#         {
#           name  = "FLATNOTES_PASSWORD"
#           value = var.flatnotes_password
#         },
#         {
#           name  = "FLATNOTES_SECRET_KEY"
#           value = var.flatnotes_secret_key
#         }
#       ]
#     }
#   ])
# }
