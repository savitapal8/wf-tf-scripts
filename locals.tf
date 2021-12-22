locals {
    name_prefix = join("-", [
    var.org, 
    var.country,
    var.env,
    "[SERVICE]",     
    var.appid]
  )

  # Specific prefix for service’s resources
  /*
  dp_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "dp"), "-", "_") 
  bq_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "bq"), "-", "_")
  kms_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "kms"), "-", "_") 
  gcs_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "gcs"), "-", "_")
  log_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "log"), "-", "_")
  */
  dp_prefix   = replace(local.name_prefix, "[SERVICE]", "dp") 
  bq_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "bq"), "-", "_")
  kms_prefix  = replace(local.name_prefix, "[SERVICE]", "kms")
  gcs_prefix  = replace(local.name_prefix, "[SERVICE]", "gcs")
  log_prefix  = replace(local.name_prefix, "[SERVICE]", "log")
  cf_prefix  = replace(local.name_prefix, "[SERVICE]", "cf")
  vpc_prefix  = replace(local.name_prefix, "[SERVICE]", "vpc")
  ps_prefix  = replace(local.name_prefix, "[SERVICE]", "ps")
}

data "google_project" "project" {
    project_id = var.project_id
}
