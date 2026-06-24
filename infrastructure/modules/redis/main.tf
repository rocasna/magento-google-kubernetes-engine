resource "google_redis_instance" "cache" {
  name               = "${var.env}-magento-redis"
  tier               = "BASIC" # Suficiente para dev
  memory_size_gb     = 1
  region             = var.region
  authorized_network = var.vpc_id

  redis_version     = "REDIS_7_2"
  display_name      = "Magento Redis Cache"
}