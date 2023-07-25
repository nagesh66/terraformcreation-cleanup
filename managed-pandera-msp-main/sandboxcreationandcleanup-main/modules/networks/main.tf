resource "google_compute_network" "sandboxcreationandcleanupnetwork" {
  name = var.vpc_name
  auto_create_subnetworks = false
  delete_default_routes_on_create = false
  project = var.project_id
}