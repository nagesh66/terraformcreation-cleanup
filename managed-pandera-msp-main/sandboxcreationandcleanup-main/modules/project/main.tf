#label=msp-terraform-managed
#Project location - This would be the Organization->Folder where the project would live.  We have a lot of Orgs in play these days.  If possible it would be nice to create any new projects in the 66degrees.com org where we could have an R&D folder for sandboxes and Ops folders for each business unit. 

# Create the project
resource "google_project" "project" {
  name              = var.project_name
  project_id        = var.project_id
  folder_id         = var.folder_id
  billing_account   = var.billing_id
  auto_create_network = false

  # Tags or labels to identify the project
  labels = {
    env       = var.env
  }
  #skip_delete = true
}


