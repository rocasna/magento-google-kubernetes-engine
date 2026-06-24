# Salida de la red VPC
output "vpc_id" {
  value = module.networking.vpc_id
}

# Salida de la subred
output "subnet_id" {
  value = module.networking.subnet_id
}

# Salida del router
output "router_id" {
  value = module.networking.router_id
}

# Salida del NAT
output "nat_id" {
  value = module.networking.nat_id
}

# Salida del nombre de la instancia de Cloud SQL
output "cloud_sql_instance_name" { 
  value = module.cloud_sql.db_instance_name
} 

# Salida del nombre de la base de datos
output "cloud_sql_db_name" {
  value = module.cloud_sql.db_name
}
