resource "google_dialogflow_cx_agent" "full_agent" {
  project = var.project_id
  display_name = "${local.df_prefix}-loanagent" 
  location = "us-central1"
  default_language_code = "en"
  supported_language_codes = ["fr","de","es"]
  time_zone = "America/New_York"
  description = "Example description."
  avatar_uri = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
  enable_stackdriver_logging = true
  enable_spell_correction    = false
    speech_to_text_settings {
        enable_speech_adaptation = true
    }
 }

resource "google_dialogflow_cx_intent" "basic_intent" {
  parent       = google_dialogflow_cx_agent.full_agent.id
  display_name = "Example"
  priority     = 1
  description  = "Intent example"
  training_phrases {
     parts {
         text = "training"
     }

     parts {
         text = "phrase"
     }

     parts {
         text = "example"
     }

     repeat_count = 1
  }

  parameters {
    id          = "param1"
    entity_type = "projects/-/locations/-/agents/-/entityTypes/sys.date"
  }

  labels  = {
      "category" = "loan",
      "sub-category" = "application"
   } 
}