
#common
environment = "prd"
region      = "eu-west-3"


#App
docker_image        = "digitalocean/flask-helloworld"
app_name            = "hello-groovWorld"
fargate_memory      = "512"
fargate_cpu         = "256"
app_container_port  = "5000"


#VPC

vpc_cidr             = "10.30.0.0/16"
public_subnets_cidr  = ["10.30.1.0/24", "10.30.2.0/24"]
private_subnets_cidr = ["10.30.10.0/24", "10.30.20.0/24"]
availability_zones   = ["eu-west-3a", "eu-west-3b"]

#Loadbalancer

lb_tg_proto                     = "HTTP"
lb_tg_port                      = "5000"
lb_tg_health_check_port         = "5000"

