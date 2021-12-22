resource "google_vpc_access_connector" "vpc_conn_example" {
  name          = "vpc-connector12"
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.vpc_network_1.id
}

resource "google_compute_network" "vpc_network_1" {
 name                            = "${local.vpc_prefix}-vpc1"
 auto_create_subnetworks         = false    # Creating as custom VPC mode
 delete_default_routes_on_create = true
}

resource "google_compute_network" "vpc_network_2" {
 name                            = "${local.vpc_prefix}-vpc2"
 auto_create_subnetworks         = false    # Creating as custom VPC mode
 delete_default_routes_on_create = true
}

# Create VPC Peering from VPC 1 to VPC 2
resource "google_compute_network_peering" "peering1" {
  name         = "${local.vpc_prefix}-peering1"
  network      = google_compute_network.vpc_network_1.id
  peer_network = google_compute_network.vpc_network_2.id
}

# Create VPC Peering from VPC 2 to VPC 1
resource "google_compute_network_peering" "peering2" {
  name         = "${local.vpc_prefix}-peering2"
  network      = google_compute_network.vpc_network_2.id
  peer_network = google_compute_network.vpc_network_1.id
}


# Create Static route for internet access
resource "google_compute_route" "default_internet" {
  name        = "${local.vpc_prefix}-route"
  dest_range  = "0.0.0.0/0"
  network     = google_compute_network.vpc_network_1.name
  next_hop_ip = "10.0.0.6"
}

# Create Subnet
resource "google_compute_subnetwork" "vpc_subnet" {
 name          = "${local.vpc_prefix}-subnet"
 ip_cidr_range = "10.0.0.0/16"
 region        = "us-central1"
 network       = google_compute_network.vpc_network_1.id
 }

