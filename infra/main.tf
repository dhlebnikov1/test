terraform {
  required_version = ">= 0.12.0"
  backend "gcs" {
    bucket      = "tf-ops-bucket"
    prefix      = "tf/state"
    credentials = "./credentials.json"
  }
}
