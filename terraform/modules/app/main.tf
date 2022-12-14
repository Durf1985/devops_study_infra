resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["reddit-app"]
  boot_disk {
    initialize_params { image = var.app_disk_image }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.app_ip.address
    }
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}
resource "null_resource" "app" {
  count = var.app_provision_enabled ? 1 : 0

  connection {
    type = "ssh"

    host        = google_compute_address.app_ip.address
    user        = "appuser"
    agent       = false
    private_key = file(var.private_key_path) // переопределяется в проде или стейдже, здесь просте объявляется
  }

  provisioner "remote-exec" {
    inline = [
      "echo DATABASE_URL=${var.db_address} | sudo tee -a /etc/default/puma",
    ]
  }

}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"


}
resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = var.app_port
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}


