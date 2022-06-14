project = "internal-test-prj-ly"
composer_env_name = "composer-test-v2"
network = "default"
network_project_id = "internal-test-prj-ly"
subnetwork = "default"
composer_service_account = "composer-test-v2@internal-test-prj-ly.iam.gserviceaccount.com"
image_version = "composer-2.0.16-airflow-2.2.5"
use_private_environment = true
enable_private_endpoint = true
airflow_config_overrides = {
  webserver-rbac_user_registration_role=""
}
