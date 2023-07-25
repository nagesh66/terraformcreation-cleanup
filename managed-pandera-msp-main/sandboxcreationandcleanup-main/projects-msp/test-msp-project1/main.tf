locals {
  project_id = "${var.project_name}-${var.requested_date}"
}

module "project" {
    source = "../../modules/project"
    project_name            =   var.project_name
    project_id              =   local.project_id
    folder_id               =   var.folder_id
    billing_id              =   var.billing_id
}
/**********************************************************NETWORK***********************************************************************************************************/
module "networks" {
    source = "../../modules/networks"
    project_id =   local.project_id
    vpc_name  =   var.vpc_name
    depends_on = [
      module.project,

    ]
}

/******************************************************* PROJECT USERS CONFIG*******************************************************************************************/
module "user_config"{
    source = "../../modules/users"
    owners_members = var.owners_members
    project_id     =   local.project_id
     depends_on = [
      module.project
    ]
}

/******************************************************* API ENABLEMENT*******************************************************************************************/

resource "google_project_service" "enable_project_services" {
  project   = local.project_id
  for_each  = toset(var.project_services_to_enable)
  service   = each.key
  depends_on =[
    module.project
  ]
}


/******************************************************* PROJECT MONITORING ALERT*******************************************************************************************/

module "monitoring_alert"{
    source = "../../modules/alert"
    project_name    =   local.project_id
    billing_id      =   var.billing_id
    project_no      =   module.project.project_no
    approved_budget = var.approved_budget
    members         =   var.notification_members
     depends_on = [
      module.project
    ]
}

