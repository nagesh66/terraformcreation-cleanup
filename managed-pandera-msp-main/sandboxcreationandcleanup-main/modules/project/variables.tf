variable "project_id" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}
variable "project_name" {
  description = "The name of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}
variable "folder_id" {
  description = "The ID of the folder in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}
variable "billing_id" {
  description = "The ID of the folder in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}

#new variables
variable "env" {
  type = string
  default = "msp-terraform-managed"
}


