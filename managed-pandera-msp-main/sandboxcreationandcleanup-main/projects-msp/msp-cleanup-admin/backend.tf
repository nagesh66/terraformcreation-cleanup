terraform {
  backend "gcs" {
    bucket = "msp-managed-admin-state-bucket"
    prefix = "/admin"
  }
}


# terraform {
#   backend "local" {
#     # Configuration settings for the local backend
#     path = "terraform.tfstate"
#   }
# }