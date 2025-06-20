resource "aws_ecs_cluster" "cluster" {
  name = "cluster-ecs"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "tarea"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "nodejs-app"
    image = aws_ecr_repository.prueba_repository.repository_url
    portMappings = [{
      containerPort = 8080
      protocol      = "tcp"
    }]
  }])
}

resource "aws_ecr_repository" "prueba_repository" {
  name = "prueba-repository"
}

resource "aws_ecs_service" "servicio" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 5
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "nodejs-app"      
    container_port   = 8080              
  }

  network_configuration {
    subnets         = data.aws_subnets.selected.ids
    security_groups = [aws_security_group.ecs_app_sg.id]
    assign_public_ip = true
  }

  depends_on = [aws_lb_listener.alb_listener]
}
