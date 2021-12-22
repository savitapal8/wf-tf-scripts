
resource "google_container_cluster" "primary" {
  name     = "${local.gke_prefix}_cl1233"
  location = "us-central1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
      enable_private_nodes = true
      enable_private_endpoint = true
      master_ipv4_cidr_block = "10.0.1.0/28"
  }

  master_authorized_networks_config {
    }

  ip_allocation_policy {
      cluster_ipv4_cidr_block = null
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${local.gke_prefix}_np1234"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.example.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}