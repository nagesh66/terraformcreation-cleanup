resource "google_storage_bucket" "function_bucket" {
    name     = "${var.project_id}-function"
    location = var.region
    project = var.project_id
}


# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source" {
    type        = "zip"
    source_dir  = var.source_dir
    output_path = "./tmp/function.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "zip" {
    source       = data.archive_file.source.output_path
    content_type = "application/zip"

    # Append to the MD5 checksum of the files's content
    # to force the zip to be updated as soon as a change occurs
    name         = "src_code-${data.archive_file.source.output_md5}.zip"
    bucket       = google_storage_bucket.function_bucket.name

    # Dependencies are automatically inferred so these lines can be deleted
    depends_on   = [
        google_storage_bucket.function_bucket,  # declared in `storage.tf`
        data.archive_file.source
    ]
}



# Create a Cloud Function
resource "google_cloudfunctions_function" "my_function_throughterraform" {
  name        = var.function_name
  project     = var.project_id
  region      = var.region
  runtime     = var.runtime
  entry_point = var.entry_point
  service_account_email = var.sa_email

  # Trigger the function via HTTP
  trigger_http = true

    # Get the source code of the cloud function as a Zip compression
    source_archive_bucket = google_storage_bucket.function_bucket.name
    source_archive_object = google_storage_bucket_object.zip.name

       # Dependencies are automatically inferred so these lines can be deleted
    depends_on            = [
        google_storage_bucket.function_bucket,  # declared in `storage.tf`
        google_storage_bucket_object.zip
    ]    
}
#---------cloud scheduler creation--------------#

resource "google_cloud_scheduler_job" "function_scheduler" {
  name     = "function-scheduler"
  schedule = "0 9 * * *"
  time_zone = "Etc/UTC"

  http_target {
    uri = google_cloudfunctions_function.my_function_throughterraform.https_trigger_url
    http_method = "GET"
      oidc_token {
      service_account_email = var.sa_email
    }
  }
  region = "us-central1"
  project = var.project_id
}