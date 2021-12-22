resource "google_storage_bucket" "bucket" {
  name     = "${local.gcs_prefix}-12346"
  location = "us"
}

resource "google_storage_bucket_object" "archive" {
  name   = "${local.gcs_prefix}-12345"
  bucket = google_storage_bucket.bucket.name
  source = "./python_code/main.zip"
}