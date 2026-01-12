resource "aws_lb" "env" {
  for_each           = local.envs
  name               = local.alb_name[each.key]
  load_balancer_type = "application"
  subnets            = [for s in aws_subnet.public : s.id]
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "blue" {
  for_each    = local.envs
  name        = substr("${local.prefix}-${each.key}-tg-blue", 0, 32)
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.this.id

  health_check {
    path    = var.healthcheck_path
    matcher = "200"
  }
}

resource "aws_lb_target_group" "green" {
  for_each    = local.envs
  name        = substr("${local.prefix}-${each.key}-tg-green", 0, 32)
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.this.id

  health_check {
    path    = var.healthcheck_path
    matcher = "200"
  }
}

resource "aws_lb_listener" "http" {
  for_each          = local.envs
  load_balancer_arn = aws_lb.env[each.key].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue[each.key].arn
  }
}
