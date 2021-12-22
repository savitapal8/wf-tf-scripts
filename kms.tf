resource "google_kms_key_ring" "app_keyring" {
  name     = "${local.kms_prefix}-keyring"
  location = "us"
  project   = var.project_id
}

resource "google_kms_crypto_key" "secret" {
 name     = "${local.kms_prefix}-key"
 key_ring = var.key_ring
}

resource "google_kms_key_ring_import_job" "example" {
  key_ring         = var.key_ring
  # Job ID must be unique, including the version number in the ID to achieve this.
  import_job_id    = "${local.kms_prefix}-imp1234"
  import_method    = "RSA_OAEP_4096_SHA1_AES_256"
  protection_level = "HSM"
}