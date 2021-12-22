resource "google_dataproc_cluster" "cluster-wsar" {
  name     = "${local.dp_prefix}-dpcluster"
  provider = google-beta
  project = "airline1-sabre-wolverine"
  region   = "us-central1"

  graceful_decommission_timeout = "120s"

  labels = {
    gcp_region = "us-central1"
    owner = "wf"
    application_division = "pci"
    application_name = ""
    application_role = "auth"
    environment = "dev"
    au = ""
    created = "20211001"
  }

  cluster_config {
    staging_bucket = "dataproc-staging-bucket123"

    gce_cluster_config {
      tags = ["foo", "bar"]

      subnetwork = "projects/airline1-sabre-wolverine/regions/us-central1/subnetworks/us-dev-appid-syst-demo-subnet"

      # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
      service_account = null     
    }
   
    master_config {
      num_instances = 1
      machine_type  = "e2-medium"
    }

    worker_config {
      num_instances    = 2
      machine_type     = "e2-medium"
      #min_cpu_platform = "Intel Skylake"
    }

    preemptible_worker_config {
      num_instances = 0
    }

    # Override or set some custom properties
    software_config {
      image_version = "1.3.7-deb9"
      override_properties = {
        "dataproc:dataproc.allow.zero.workers" = "true"
      }
    }


    encryption_config{
        kms_key_name = ""
    }

     endpoint_config{
        enable_http_port_access = false
    }
  }
}