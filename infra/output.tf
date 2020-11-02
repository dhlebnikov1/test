output "kubernetes_master_version" {
  description = "Kunernetes master version"
  value       = "${google_container_cluster.test_dev.master_version}"
}
