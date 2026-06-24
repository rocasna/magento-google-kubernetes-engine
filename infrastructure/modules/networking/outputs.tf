# Salida de la red VPC
output "vpc_id" {
  value = google_compute_network.main.id
}

# Salida de la subred
output "subnet_id" {
  value = google_compute_subnetwork.gke_subnet.id
}

# Salida del router
output "router_id" {
  value = google_compute_router.router.id
}

# Salida del NAT
output "nat_id" {
  value = google_compute_router_nat.nat.id
}