#-------------------------------
# frontend LB
#-------------------------------
resource "aws_lb" "frontend" {
  name               = "aws-lb-frontend"
  internal           = false
  subnets            =  module.vpc.public_subnets
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_frontend.id]
}

resource "aws_lb_listener" "frontend" {
  
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"
  #ssl_policy        = lookup(var.acm_certificate_arn, "") != "" ? "ELBSecurityPolicy-FS-2018-06" : null
  #certificate_arn   = lookup(var.acm_certificate_arn, "") != "" ? var.acm_certificate_arn : null)
  depends_on        = [aws_lb_target_group.frontend]
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

#-------------------------------
# Target Group
#-------------------------------
resource "aws_lb_target_group" "frontend" {
  
  name                 = var.frontend_service_name
  port                 = var.frontend_container_port
  protocol             = "HTTP"
  vpc_id               = module.vpc.vpc_id
  target_type          = "ip"
  deregistration_delay = 300

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.healthcheck_timeout
    protocol            = var.healthcheck_protocol
    path                = var.healthcheck_path
    interval            = var.healthcheck_interval
    matcher             = var.healthcheck_matcher
  }
}

#-------------------------------
# Backend LB
#-------------------------------
resource "aws_lb" "backend" {
  name               = "aws-lb-backend"
  internal           = true
  subnets            =  module.vpc.private_subnets
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_backend.id]
}

resource "aws_lb_listener" "backend" {
  
  load_balancer_arn = aws_lb.backend.arn
  port              = 5000
  protocol          = "HTTP"
  #ssl_policy        = lookup(var.acm_certificate_arn, "") != "" ? "ELBSecurityPolicy-FS-2018-06" : null
  #certificate_arn   = lookup(var.acm_certificate_arn, "") != "" ? var.acm_certificate_arn : null)
  depends_on        = [aws_lb_target_group.backend]
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

resource "aws_lb_target_group" "backend" {
  
  name                 = var.backend_service_name
  port                 = var.backend_container_port
  protocol             = "HTTP"
  vpc_id               = module.vpc.vpc_id
  target_type          = "ip"
  deregistration_delay = 300

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.healthcheck_timeout
    protocol            = var.healthcheck_protocol
    path                = var.healthcheck_path
    interval            = var.healthcheck_interval
    matcher             = var.healthcheck_matcher
  }
}