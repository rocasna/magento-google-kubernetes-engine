# Variables para Redis
variable "project_id" {
  description = "ID del proyecto de Google Cloud"
  type        = string
  
}
variable "env" {
  description = "Entorno"
  type        = string
}

variable "region" {
  description = "Región de GCP"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC para la conexión privada"
  type        = string
}
