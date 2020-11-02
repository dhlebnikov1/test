variable "project_id" {
  default = "titanium-goods-275412"
  type    = string
}

variable "region" {
  default = "europe-west1"
  type    = string
}

variable "zone" {
  default = "europe-west1-d"
  type    = string
}

variable "node_count" {
  default = "3"
  type    = number
}

variable "machine_type" {
  default = "e2-medium"
  type    = string
}

variable "kube_version" {
  default = "1.16.13-gke.401"
  type    = string
}

variable "ip_cidr_range" {
  default = "10.10.0.0/20"
  type    = string
}
