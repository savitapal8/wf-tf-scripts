
resource "google_kms_crypto_key_iam_member" "encryption" {
 crypto_key_id = google_kms_crypto_key.secret.id
 role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
 member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_topic" "pb_topic" {
 project      = data.google_project.project.project_id
 name         = "${local.ps_prefix}-pub"
 labels = {
    owner = "hybridenv"
    application_division = "pci"
    application_name = "app1"
    application_role = "auth"
    au = "0223092"
    gcp_region = "us" 
    environment = "dev" 
    created = "20211124" 
  }
 kms_key_name = google_kms_crypto_key.secret.id
}

resource "google_pubsub_topic_iam_member" "member" {
  project      = "airline1-sabre-wolverine"
  topic   = google_pubsub_topic.pb_topic.name
  role    = "roles/pubsub.admin"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_subscription" "subsc" {
 project      = "airline1-sabre-wolverine"
 name         = "${local.ps_prefix}-subsc"
 topic = google_pubsub_topic.pb_topic.name
 labels = {
    owner = "hybridenv"
    application_division = "pci"
    application_name = "app1"
    application_role = "auth"
    au = "0223092"
    gcp_region = "us" 
    environment = "dev" 
    created = "20211124" 
  }

 # Only allow to storage messages in the following regions
 message_retention_duration = "604800s"
}