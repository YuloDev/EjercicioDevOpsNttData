resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Permite acceso HTTP al puerto 3000"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Acceso HTTP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
