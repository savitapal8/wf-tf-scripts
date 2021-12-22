#create a new regional cloud logging bucket
resource "google_logging_project_bucket_config" "regional_dialog" {
    project       = var.project_id
    location      = "us-central1"
    retention_days = 400
    bucket_id = "${local.gcs_prefix}-dialogflow" 
}

#create a new sink for Dialogflow logs that points to new regional cloud logging bucket
resource "google_logging_project_sink" "dialog-sink" {
  name = "${local.log_prefix}-logsink"
  destination = "logging.googleapis.com/projects/${var.project_id}/locations/${lower(google_logging_project_bucket_config.regional_dialog.location)}/buckets/${google_logging_project_bucket_config.regional_dialog.bucket_id}"
  filter = <<EOF
    LOG_ID("dialogflow-runtime.googleapis.com/requests")
    EOF
    unique_writer_identity = true
}