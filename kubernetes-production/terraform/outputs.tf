output "master_external_ip" {
  value = google_compute_instance.master.network_interface.0.access_config.0.nat_ip
}
output "worker1_external_ip" {
  value = google_compute_instance.worker1.network_interface.0.access_config.0.nat_ip
}
output "worker2_external_ip" {
  value = google_compute_instance.worker2.network_interface.0.access_config.0.nat_ip
}
output "worker3_external_ip" {
  value = google_compute_instance.worker3.network_interface.0.access_config.0.nat_ip
}
