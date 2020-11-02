provider "google" {
  credentials = file("credentials.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  version     = "~> 3.26"
}

provider "google-beta" {
  credentials = file("credentials.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  version     = "~> 3.26"
}

provider "random" {
  version = "~> 2.2"
}

provider "null" {
  version = "~> 3.0"
}
