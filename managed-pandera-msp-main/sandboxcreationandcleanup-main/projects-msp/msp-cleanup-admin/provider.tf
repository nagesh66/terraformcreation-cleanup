provider "google" {
  project     =  var.project_name
  credentials = file(var.credential_file)
}
