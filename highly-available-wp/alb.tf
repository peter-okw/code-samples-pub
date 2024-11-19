## Create the Application Load Balancer (ALB) to front AutoScaling Group
resource "aws_lb" "nacent-alb" {
  name               = "nacent-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nacent-alb-sg.id]
  subnets            = [for subnet in aws_subnet.nacent-public-subnet : subnet.id]

  tags = {
    Name = "nacent-alb"
  }
}

## Create the Target Group for the ALB
resource "aws_lb_target_group" "nacent-wp-tg" {
  name     = "nacent-wp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.nacent-vpc.id
  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "nacent-wp-tg"
  }
}

## Create a Listener for the ALB to forward requests to the Target Group
resource "aws_lb_listener" "nacent-wp-listener" {
  load_balancer_arn = aws_lb.nacent-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nacent-wp-tg.arn
  }
}
