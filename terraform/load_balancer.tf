

resource "aws_lb" "alb" {
  name               = "prueba-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_app_sg.id]
  subnets            = data.aws_subnets.selected.ids
}


resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"


  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 5
    matcher             = "200"
  }

}


resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}



