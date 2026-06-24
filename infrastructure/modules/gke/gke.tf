resource "google_container_cluster" "primary" {
  name     = "${var.env}-magento-cluster"
  location = var.region # "location" en la región hace el cluster Regional (más estable)

  deletion_protection = false
  
  # Usamos la red que acabas de crear
  network    = var.network_id
  subnetwork = var.subnetwork_id

# 1. ACTIVAR WORKLOAD IDENTITY (Requerido para GCS Fuse)
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Habilitamos Alias IPs para usar los rangos secundarios de tu plan
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_range_name
    services_secondary_range_name = var.service_range_name
  }

  # Recomendado: Cluster Privado
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false # Para que puedas acceder al API desde tu PC
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # Eliminamos el pool de nodos por defecto para crear uno personalizado después
  remove_default_node_pool = true
  initial_node_count       = 1

  node_config {
    disk_type    = "pd-standard"
    disk_size_gb = 30
  }
  # Vital para el almacenamiento de Media que hablamos:
  addons_config {
    gcs_fuse_csi_driver_config {
      enabled = true
    }
  }
}

# Pool de nodos optimizado para PHP/Magento
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.env}-${var.app}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true # Más barato para DEV
    machine_type = "e2-standard-4" # 4 vCPU y 16GB RAM
    disk_type    = "pd-standard" # Cambiamos SSD por Standard
    disk_size_gb = 50            # Reducimos de 100GB a 30GB

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      env = var.env
    }

    # Permisos mínimos para que los nodos funcionen
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}