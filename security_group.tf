#-------------------------------
# LB Security Group
#-------------------------------
resource "aws_security_group" "lb_frontend" {
  vpc_id      = module.vpc.vpc_id
  name        = "lb_frontend"
  description = "controls access to the Application Load Balancer (ALB)"

  ingress {
      protocol    = "tcp"
      #rule_no    = 100
      from_port   = 80
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      protocol    = "tcp"
      #rule_no    = 101
      from_port   = 0
      to_port     = 65535
      security_groups = [aws_security_group.lb_backend.id]
      #security_group_id = aws_security_group.lb_frontend
      #depends_on = [aws_security_group.lb_backend]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_backend" {
  
  vpc_id      = module.vpc.vpc_id
  name        = "lb_backend"
  description = "controls access to the Application Load Balancer (ALB)"

  ingress {
      protocol    = "tcp"
      from_port   = 5000
      to_port     = 5000
      cidr_blocks = [var.cidr]
      #security_groups = [aws_security_group.lb_frontend.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "frontend_service" {
  
  vpc_id      = module.vpc.vpc_id
  name        = "fronnt_service"
  description = "controls access to the front end service"

  ingress {
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      cidr_blocks = [var.cidr]
      #security_group_id = aws_security_group.lb_frontend
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_service" {
  
  vpc_id      = module.vpc.vpc_id
  name        = "backend_service"
  description = "controls access to the backend service"

  ingress {
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      cidr_blocks = [var.cidr]
      #security_group_id = aws_security_group.lb_frontend
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}