project = "modular-scout-345114"
composer_env_name = "composer-test-v2"
network = "default"
network_project_id = "modular-scout-345114"
subnetwork = "default"
composer_service_account = "composer-test-v2@modular-scout-345114.iam.gserviceaccount.com"
image_version = "composer-2.0.16-airflow-2.2.5"
use_private_environment = true
enable_private_endpoint = true
airflow_config_overrides = {
  webserver-rbac_user_registration_role=""
}
