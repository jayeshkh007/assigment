resource "aws_cloudwatch_log_group" "backend" {
  name = var.backend_service_name
}

# -------------------------------
#   Task Definition
# -------------------------------
resource "aws_ecs_task_definition" "backendtask" {
  family                   = var.backend_service_name
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_definition_cpu
  memory                   = var.task_definition_memory
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
  {
     name    = var.backend_service_name
     image   = var.backend_container_image
     portMappings = [
       {
         containerPort = var.backend_container_port
         hostPort      = var.backend_host_port
       }
     ]
     logConfiguration = {
       logDriver = "awslogs"
       options = {
         awslogs-group         = "backend"
         awslogs-region        = "us-west-1"
         awslogs-stream-prefix = "ecs"
       }
     }
   }
  ])
}

# -------------------------------
#  frontend Service Of Fargate
# -------------------------------

resource "aws_ecs_service" "backend_lb" {
  name            = var.backend_service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.backendtask.arn
  launch_type     = "FARGATE"

  desired_count                      = var.task_count
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  network_configuration {
    security_groups  = [aws_security_group.backend_service.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = var.backend_service_name
    container_port   = var.backend_container_port
  }

  # desired_count: ignore for autoscale
  # task_definition: ignore for deploy
  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }
  depends_on = [aws_lb_target_group.backend, aws_lb_listener.backend, aws_lb.backend, aws_security_group.lb_backend]
}