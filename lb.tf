# VPC
resource "google_compute_network" "ilb_network" {
  name                    = "${local.vpc_prefix}-vpc1"
  provider                = google-beta
  auto_create_subnetworks = false
}

# proxy-only subnet
resource "google_compute_subnetwork" "proxy_subnet" {
  name          = "${local.vpc_prefix}-pxsubnet"
  provider      = google-beta
  ip_cidr_range = "10.0.0.0/24"
  region        = "europe-west1"
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  network       = google_compute_network.ilb_network.id
}

# backed subnet
resource "google_compute_subnetwork" "ilb_subnet" {
  name          = "${local.vpc_prefix}-subnet12"
  provider      = google-beta
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west1"
  network       = google_compute_network.ilb_network.id
}

# forwarding rule
resource "google_compute_forwarding_rule" "google_compute_forwarding_rule" {
  name                  = "${local.lb_prefix}-tcpilb"
  provider              = google-beta
  region                = "europe-west1"
  depends_on            = [google_compute_subnetwork.proxy_subnet]
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "443"
  all_ports             = true
  target                = google_compute_region_target_https_proxy.default.id
  network               = google_compute_network.ilb_network.id
  subnetwork            = google_compute_subnetwork.ilb_subnet.id
  network_tier          = "PREMIUM"
}

# http proxy
resource "google_compute_region_target_https_proxy" "default" {
  region           = "europe-west1"
  name             = "${local.lb_prefix}-httpsproxy"
  url_map          = google_compute_region_url_map.default.id
  ssl_certificates = [google_compute_region_ssl_certificate.default.id]
}

# ssl certificate
resource "google_compute_region_ssl_certificate" "default" {
  region      = "europe-west1"
  name        = "${local.ssl_prefix}-ssl123"
  private_key = file("certs/keystore.key")
  certificate = file("certs/certificate.crt")
}

# url map
resource "google_compute_region_url_map" "default" {
  name            = "${local.lb_prefix}-url123"
  provider        = google-beta
  region          = "europe-west1"
  default_service = google_compute_region_backend_service.default.id
  
   host_rule {
    hosts        = ["test.example.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.default.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_region_backend_service.default.id
    }
 }
}

# backend service
resource "google_compute_region_backend_service" "default" {
  name                  = "${local.lb_prefix}-lbbackend123"
  provider              = google-beta
  region                = "europe-west1"
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec           = 10
  health_checks         = [google_compute_region_health_check.default.id]
  backend {
    group           = google_compute_region_instance_group_manager.mig.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

# instance template
resource "google_compute_instance_template" "instance_template" {
  name         = "l7-ilb-mig-template"
  provider     = google-beta
  machine_type = "e2-small"
  tags         = ["http-server"]

  network_interface {
    network    = google_compute_network.ilb_network.id
    subnetwork = google_compute_subnetwork.ilb_subnet.id
    access_config {
      # add external ip to fetch packages
    }
  }
  disk {
    source_image = "debian-cloud/debian-10"
    auto_delete  = true
    boot         = true
  }

  # install nginx and serve a simple web page
  metadata = {
    startup-script = <<-EOF1
      #! /bin/bash
      set -euo pipefail

      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y nginx-light jq

      NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
      IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")
      METADATA=$(curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/?recursive=True" | jq 'del(.["startup-script"])')

      cat <<EOF > /var/www/html/index.html
      <pre>
      Name: $NAME
      IP: $IP
      Metadata: $METADATA
      </pre>
      EOF
    EOF1
  }
  lifecycle {
    create_before_destroy = true
  }
}

# health check
resource "google_compute_region_health_check" "default" {
  name     = "${local.lb_prefix}-lbbackend"
  provider = google-beta
  region   = "europe-west1"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

# MIG
resource "google_compute_region_instance_group_manager" "mig" {
  name     = "my-dev-appid-strg-demolb1-mig1"
  provider = google-beta
  region   = "europe-west1"
  version {
    instance_template = google_compute_instance_template.instance_template.id
    name              = "primary"
  }
  base_instance_name = "vm"
  target_size        = 2
}