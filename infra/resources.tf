### VPC
resource "google_compute_network" "test_vpc_network" {
  name                    = "test-network"
  mtu                     = 1460
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "test_vpc_subnetwork" {
  name          = "test-subnetwork"
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = google_compute_network.test_vpc_network.id
}

### Kube
resource "google_container_cluster" "test_dev" {
  name                     = "test-dev"
  location                 = var.zone
  min_master_version       = var.kube_version
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.test_vpc_network.name
  subnetwork = google_compute_subnetwork.test_vpc_subnetwork.name

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }
}

resource "google_container_node_pool" "test_dev_pool" {
  name       = "test-dev-pool"
  location   = var.zone
  cluster    = google_container_cluster.test_dev.name
  node_count = var.node_count
  version    = var.kube_version
  node_config {
    preemptible  = true
    machine_type = var.machine_type
    disk_type    = "pd-standard"
    disk_size_gb = 100
    image_type   = "COS"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      project = "test-dev"
    }

    tags = ["test-dev"]
  }
  management {
    auto_repair  = true
    auto_upgrade = false
  }
}

resource "null_resource" "get_cluster_creds" {
  depends_on = [google_container_node_pool.test_dev_pool]
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.test_dev.name} --zone ${var.zone} --project ${var.project_id}"
  }
}
