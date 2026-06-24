# Variables para el módulo GKE
variable "project_id" {
  description = "ID del proyecto de Google Cloud"
  type        = string
}

variable "region" {
  description = "Región donde se desplegará el clúster"
  type        = string
}

variable "env" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
}

variable "app" {
  description = "Nombre de la aplicación"
  type        = string
}

variable "pod_range_name" {
  description = "Nombre del rango secundario para Pods"
  type        = string
}

variable "service_range_name" {
  description = "Nombre del rango secundario para Servicios"
  type        = string
}
variable "network_id" {
  description = "ID de la red VPC"
  type        = string
  
}
variable "subnetwork_id" {
  description = "ID de la subred"
  type        = string
  
}