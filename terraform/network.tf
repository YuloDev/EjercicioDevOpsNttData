data "aws_vpc" "main" {
  id = "vpc-0ad35e8ee40d0d6b8"
}


resource "aws_security_group" "alb_app_sg" {
  name   = "alb_app_sg"
  vpc_id = data.aws_vpc.main.id
}

resource "aws_security_group" "ecs_app_sg" {
  name   = "ecs_app_sg"
  vpc_id = data.aws_vpc.main.id
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}
