variable "owners_members" {
  type        = list(string)
  description = "List of users to add to the owners group"
}
variable "project_id" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
}
