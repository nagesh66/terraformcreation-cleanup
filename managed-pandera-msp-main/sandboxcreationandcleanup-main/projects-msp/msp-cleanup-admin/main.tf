locals {
  project_id = "${var.project_name}-${var.requested_date}"
}

/******************************************************* CREATING GOOGLE PROJECT *******************************************************************************************/


module "project" {
  source       = "../../modules/project"
  project_name = var.project_name
  project_id   = local.project_id
  folder_id    = var.folder_id
  billing_id   = var.billing_id
  env          = var.env
  #skip delete to be true--------- By setting skip_delete to true, the project associated with the Terraform resource will not be deleted when you run terraform destroy.
}
/******************************************************* PROJECT USERS CONFIG*******************************************************************************************/
module "user_config" {
  source         = "../../modules/users"
  owners_members = var.owners_members
  project_id     = local.project_id
  depends_on = [
    module.project
  ]
}

/******************************************************* API ENABLEMENT *******************************************************************************************/

resource "google_project_service" "enable_project_services" {
  project  = local.project_id
  for_each = toset(var.project_services_to_enable)
  service  = each.key
  depends_on = [
    module.project
  ]
}

/******************************************************* CREATING CLOUD FUNCTION AND SCHEDULER ****************************************************************************************/
module "cloufnscheduler" {
  source     = "../../modules/cloudfn_scheduler"
  project_id = local.project_id
  source_dir = var.source_dir
  #sa_email       =   local.sa_email
  depends_on = [
    module.project,
    google_project_service.enable_project_services
  ]
}



