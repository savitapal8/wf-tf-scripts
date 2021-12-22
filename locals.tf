locals {
    name_prefix = join("-", [
    var.org, 
    var.country,
    var.env,
    "[SERVICE]",     
    var.appid]
  )

  # Specific prefix for service’s resources
  dp_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "dp"), "-", "_") 
  bq_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "bq"), "-", "_")
  kms_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "kms"), "-", "_") 
  gcs_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "gcs"), "-", "_")
  log_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "log"), "-", "_")
}

data "google_project" "project" {
    project_id = var.project_id
}
