module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  
  cluster_name = var.environment

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 1
      }
    }
  }
}

resource "aws_ecs_task_definition" "API-Getway" {
  family                   = "saude-tv-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.role.arn
  container_definitions = jsonencode(
    [
      {
        "name"      = var.environment
        "image"     = "243014803482.dkr.ecr.us-east-1.amazonaws.com/saude-tv-api"
        "cpu"       = 512
        "memory"    = 1024
        "essential" = true
        "portMappings" = [
          {
            "containerPort" = 3000
            "hostPort"      = 3000
          }
        ]
      }
    ]
  )
}

resource "aws_ecs_service" "API-Getway" {
  name            = "saude-tv-api"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.API-Getway.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target.arn
    container_name   = var.environment
    container_port   = 3000
  }

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.private.id]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}
