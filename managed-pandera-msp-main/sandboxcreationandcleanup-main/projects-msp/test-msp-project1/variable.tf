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
}
variable "owners_members" {
  type        = list(string)
  description = "List of users to add to the owners group"
}
variable "vpc_name" {
  description = "Network name"
  type        = string
}

variable "notification_members" {
  type        = string
}
variable "approved_budget" {
  description = "Amount of budget approved for this project"
  default     = "100"
}

variable "project_services_to_enable" {
  description = "List of project services to enable"
  type        = set(string)
  default     = [
    "billingbudgets.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ]
}

variable "requested_date" {
  type        = string
  default = "19700101"
}