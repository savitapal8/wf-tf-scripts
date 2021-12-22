locals {
    name_prefix = join("-", [
    var.org, 
    #var.country,
    var.env,
    "[SERVICE]",     
    var.appid]
  )

  # Specific prefix for service’s resources
  bq_prefix  = replace(replace(local.name_prefix, "[SERVICE]", "bq"), "-", "_")
  kms_prefix = replace(local.name_prefix, "[SERVICE]", "kms")
}