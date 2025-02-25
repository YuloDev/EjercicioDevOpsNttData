resource "aws_ecs_service" "service" {
  name            = "express-app-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public.id]
    security_groups = [module.security.ecs_service_sg.id]
    assign_public_ip = true
  }
}
