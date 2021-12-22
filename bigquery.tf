resource "google_kms_crypto_key_iam_member" "bq_encryption_iam" {
 crypto_key_id = google_kms_crypto_key.secret.id
 role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
 member        = "serviceAccount:bq-${data.google_project.project.number}@bigquery-encryption.iam.gserviceaccount.com"
}

resource "google_bigquery_dataset" "dataset" {
  depends_on   = [google_kms_crypto_key.secret]
  dataset_id   = "${local.bq_prefix}-bqds"
  default_encryption_configuration {
    kms_key_name = google_kms_crypto_key.secret.id
  }
}