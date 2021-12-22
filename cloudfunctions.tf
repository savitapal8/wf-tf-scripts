resource "google_service_account" "example" {
 account_id   = "service-account-id1"
 display_name = "Function Example Service Account"
 project      = var.project_id
}

resource "google_cloudfunctions_function" "function" {
  name        = "${local.cf_prefix}-12234"
  description = "My function"
  runtime     = "python39"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  timeout               = 60
  entry_point           = "hello_world"
  labels = {
    my-label = "my-label-value"
  }

  environment_variables = {
    MY_ENV_VAR = "my-env-var-value"
    GOOGLE_FUNCTION_SOURCE = "main.py"
  }
  
  ingress_settings = "ALLOW_INTERNAL_ONLY"
  vpc_connector    = google_vpc_access_connector.vpc_conn_example.id
  vpc_connector_egress_settings = "ALL_TRAFFIC"
  service_account_email = google_service_account.example.email
}