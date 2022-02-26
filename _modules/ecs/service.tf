resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.environment}-${var.app_name}-ecs-svc"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = var.private_subnets_id
    assign_public_ip = false
    security_groups = [
      aws_security_group.load_balancer.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.environment}-${var.app_name}-container"
    container_port   = var.app_container_port
  }

}

resource "aws_alb" "application_load_balancer" {
  name               = "${var.environment}-${var.app_name}-alb"
  load_balancer_type = "application"
  internal           = false
  subnets            = var.public_subnets_id
  security_groups    = [aws_security_group.load_balancer.id]

  tags = {
    Name        = "${var.environment}"
    Environment = var.environment
  }
}

resource "aws_security_group" "load_balancer" {
  vpc_id = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port = 5000
    to_port   = 5000
    protocol  = "TCP"
    self      = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.environment}-lb-sg"
    Environment = var.environment
  }
}
