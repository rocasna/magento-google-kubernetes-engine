# variables.tf
variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "env" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "app" {
  description = "The application name"
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "pod_range_name" {
  description = "The name of the pod range"
  type        = string
}

variable "pod_range_cidr" {
  description = "The CIDR block for the pod range"
  type        = string
}

variable "service_range_name" {
  description = "The name of the service range"
  type        = string
}

variable "service_range_cidr" {
  description = "The CIDR block for the service range"
  type        = string
}
