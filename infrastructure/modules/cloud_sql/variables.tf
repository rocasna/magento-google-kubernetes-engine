# Variables para la base de datos MySQL
variable "project_id" {
  description = "ID del proyecto de Google Cloud"
  type        = string
  
}
variable "db_password" {
  description = "Contraseña para el usuario de MySQL"
  type        = string
  sensitive   = true
}
variable "app" {
  
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
variable "database_user" {
  description = "User for magento in database"
  
}