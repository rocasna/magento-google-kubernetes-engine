# Crear la red VPC
resource "google_compute_network" "main" {
  project = var.project_id
  name                    = "${var.env}-${var.app}-vpc"
  auto_create_subnetworks = false
}

# Crear la subred con rangos secundarios para GKE (Alias IPs)
resource "google_compute_subnetwork" "gke_subnet" {
  project = var.project_id
  name          = "${var.env}-${var.app}-gke-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id

  secondary_ip_range {
    range_name    = var.pod_range_name
    ip_cidr_range = var.pod_range_cidr
  }
  secondary_ip_range {
    range_name    = var.service_range_name
    ip_cidr_range = var.service_range_cidr
  }
}

# Cloud NAT (Para que los Pods salgan a internet sin IP pública)
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.env}-${var.app}-router"
  region  = var.region
  network = google_compute_network.main.id
}

resource "google_compute_router_nat" "nat" {
  project                              = var.project_id
  name                                 = "${var.env}-${var.app}-nat"
  router                               = google_compute_router.router.name
  region                               = var.region
  nat_ip_allocate_option               = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat   = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# 1. Reservar rango de IPs internas para servicios de Google
resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.env}-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

# 2. Establecer la conexión privada (Peering)
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}