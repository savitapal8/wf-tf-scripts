resource "google_compute_network" "vpc_network" {
  project                 = "airline1-sabre-wolverine"
  name                    = "vpc-network"
  auto_create_subnetworks = false
  mtu                     = 1460
  delete_default_routes_on_create = true
}

resource "google_compute_interconnect_attachment" "on_prem" {
  name                     = "on-prem-attachment"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.foobar.id
  mtu                      = 1500
}

resource "google_compute_router" "foobar" {
  name    = "router"
  network = google_compute_network.vpc_network.name
  bgp {
    asn = 16550
  }
}
