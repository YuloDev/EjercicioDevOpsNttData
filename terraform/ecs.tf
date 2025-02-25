resource "aws_ecr_repository" "prueba_repository" {
  name = "prueba-repository"  
}

resource "aws_ecs_cluster" "cluster" {
  name = "cluster-ecs"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "tarea"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "nodejs-app"
    image = "${aws_ecr_repository.prueba_repository.repository_url}:latest"  
    portMappings = [{
      containerPort = 443 
      hostPort      = 443
      protocol      = "tcp"
    }]
  }])
}

