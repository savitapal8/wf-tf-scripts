provider "google" {
  user_project_override = true
  access_token          = var.access_token
  project               = var.project_id
}

provider "google-beta"{
  access_token          = var.access_token
}