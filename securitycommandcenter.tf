resource "google_scc_notification_config" "kms_notification_config_high" {
  config_id    = "${local.scc_prefix}_scc123"
  organization = var.org
  description  = "Notification when any high-severity findings is identified"
  pubsub_topic =  google_pubsub_topic.pb_topic.id
  #filter to identify high severity and active findings
  streaming_config {
    filter = "severity = \"HIGH\" AND state=\"ACTIVE\""
  }
  depends_on = [google_project_service.apis]
}

resource "google_project_service" "apis" {
 for_each           = toset(local.googleapis)
 project            = var.project_id
 service            = each.key
 disable_on_destroy = false
}