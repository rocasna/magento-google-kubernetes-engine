# main.tf
module "networking" {
  source = "../../modules/networking"
  project_id        = var.project_id
  env               = var.env
  app               = var.app
  region            = var.region
  subnet_cidr       = var.subnet_cidr
  pod_range_name    = var.pod_range_name
  pod_range_cidr    = var.pod_range_cidr
  service_range_name = var.service_range_name
  service_range_cidr = var.service_range_cidr
}

module "gke" {
  source = "../../modules/gke"
  project_id        = var.project_id
  env               = var.env
  app               = var.app
  region            = var.region
  pod_range_name    = var.pod_range_name
  service_range_name = var.service_range_name
  network_id       = module.networking.vpc_id
  subnetwork_id    = module.networking.subnet_id
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "cloud_sql" {
  source = "../../modules/cloud_sql"
  project_id = var.project_id
  env        = var.env
  region     = var.region
  vpc_id     = module.networking.vpc_id
  db_password = random_password.db_password.result
  depends_on = [module.networking]
  app = var.app
  database_user = var.database_user
}

module "redis" {
  source = "../../modules/redis"
  project_id = var.project_id
  env        = var.env
  region     = var.region
  vpc_id     = module.networking.vpc_id
}