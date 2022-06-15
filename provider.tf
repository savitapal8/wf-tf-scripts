provider "google" {
  user_project_override = true
  access_token          = var.access_token
  project               = var.project_id
  version               = "4.8.0"
}

provider "google-beta"{
  access_token          = var.access_token
  version               = "4.8.0"
}
