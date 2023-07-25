variable "project_id" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = ""
}
variable "folder_id" {
  description = "The ID of the folder in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}
variable "billing_id" {
  description = "The ID of the folder in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}
variable "credential_file" {
  type        = string
  description = "Service account key file"
  default     = ""
}
variable "project_name" {
  description = "The name of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = ""
}

variable "source_dir" {
  description = "The name of the source dir where main.py and requirements has been stored"
  type        = string
  default     = ""
}

variable "sa_email" {
  description = "The name of the service account to invoke cloud fn and add in oidc token of cloud scheduler"
  type        = string
  default     = ""
}


variable "owners_members" {
  type        = list(string)
  description = "List of users to add to the owners group"
}


variable "project_services_to_enable" {
  description = "List of project services to enable"
  type        = set(string)
  default = [
    "cloudfunctions.googleapis.com",
    "storage.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
}

variable "requested_date" {
  type    = string
  default = "19700101"
}

variable "approved_budget" {
  description = "Amount of budget approved for this project"
  default     = "100"
}

variable "env" {
  description = "making label different from test project"
  type = string
  default = "admin"
}
