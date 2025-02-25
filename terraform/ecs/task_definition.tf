resource "aws_ecs_task_definition" "task" {
  family                   = "express-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_cpu
  memory                   = var.ecs_memory
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

  container_definitions = jsonencode([
    {
      name      = "express-app",
      image     = "${module.ecr.repository_url}:${var.image_tag}",
      essential = true,
      portMappings = [{
        containerPort = 3000,
        hostPort      = 3000,
        protocol      = "tcp"
      }]
    }
  ])
}
