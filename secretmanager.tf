resource "time_static" "secret_expiration" { }

resource "google_secret_manager_secret" "secret" {
 project   = var.project_id
 secret_id = "${local.sm_prefix}-secret"

 
 # Rotation (90 days) - Notifications each 1 day
 rotation {
   next_rotation_time = timeadd(time_static.secret_expiration.rfc3339, "2160h")
   rotation_period    = "86400s"
 }

 # Configure Pub/Sub topic to send rotation notifications
 topics {
   name = "projects/{{project}}/topics/{{name}}"
 }

 # Secret expiration (120 days): WARNING secret will be deleted after this date/time!
 expire_time = timeadd(time_static.secret_expiration.rfc3339, "2880h")
}