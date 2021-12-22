resource "google_service_account" "example" {
 account_id   = "service-account-id1"
 display_name = "Function Example Service Account"
 project      = var.project_id
}
