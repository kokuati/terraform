module "prod" {
    source = "../../infra"
    
    repository_name = "saude-tv-api"
    roleIAM = "production"
    profile = "production"
    environment = "production"
}

output "IP_alb" {
  value = module.prod.IP
}