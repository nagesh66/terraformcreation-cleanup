# Grant Owner IAM role to specified users or groups
resource "google_project_iam_member" "project_owners" {
  project = var.project_id
  role    = "roles/owner"

  for_each = toset(var.owners_members)

  member = each.value
}