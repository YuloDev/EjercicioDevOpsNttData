data "aws_vpc" "main" {
  id = "vpc-0ad35e8ee40d0d6b8"
}


resource "aws_security_group" "alb_app_sg" {
  name   = "alb_app_sg"
  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
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


resource "aws_security_group" "ecs_app_sg" {
  name   = "ecs_app_sg"
  vpc_id = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}



data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}
