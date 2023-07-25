provider "google" {
  project     = "pandera-cloud-devops-terraform"
  credentials = file(var.credential_file)
}
