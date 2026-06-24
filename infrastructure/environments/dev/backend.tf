terraform {
  backend "gcs" {
    bucket  = "magento-kubernetes-terraform-state"
    prefix  = "dev"
    impersonate_service_account = "terraform-admin@magento-kubernetes-493517.iam.gserviceaccount.com"
  }
}