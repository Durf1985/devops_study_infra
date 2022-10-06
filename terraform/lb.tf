resource "google_compute_instance_template" "default" {
  name = "reddit-template"
   disk {
    auto_delete  = true
    boot         = true
    device_name  = "persistent-disk-0"
    mode         = "READ_WRITE"
    source_image = "projects/clgcporg2-118/global/images/reddit-full-1664802177" 
    type         = "PERSISTENT"
  }
  
  labels = {
    managed-by-cnrm = "true" 
  }
  machine_type = "e2-medium"
  metadata = {
    ssh-keys = "appuser:${file("${var.public_key_path}")}"
  }
  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    network    = "global/networks/default" 
    subnetwork = "regions/us-central1/subnetworks/default"
  }
  region = "us-central1-a"
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE" 
    
  }
  tags = ["reddit-app"]
}

resource "google_compute_instance_group_manager" "default" {
  name = "reddit-example"
  zone = "us-central1-a"
  named_port {
    name = "tcp"
    port = 9292
  }
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
 
  }
  base_instance_name = "vm"
  target_size        = 2
}

resource "google_compute_firewall" "default" {
  name          = "fw-allow-health-check"
  direction     = "INGRESS"
  network       = "global/networks/default"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
}

resource "google_compute_global_address" "default" {
  name       = "lb-ipv4-1"
  ip_version = "IPV4"
}

resource "google_compute_health_check" "default" {
  name               = "http-basic-check"
  check_interval_sec = 5
  healthy_threshold  = 2
  http_health_check {
    port               = 9292
    port_specification = "USE_FIXED_PORT"
    proxy_header       = "NONE"
    request_path       = "/"
  }
  timeout_sec         = 5
  unhealthy_threshold = 2
}

resource "google_compute_backend_service" "default" {
  name                            = "web-backend-service"
  connection_draining_timeout_sec = 0
  health_checks                   = [google_compute_health_check.default.id]
  load_balancing_scheme           = "EXTERNAL"
  port_name                       = "http"
  protocol                        = "HTTP"
  session_affinity                = "NONE"
  timeout_sec                     = 30
  backend {
    group           = google_compute_instance_group_manager.default.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 0.7
  }
}


resource "google_compute_url_map" "default" {
  name            = "web-map-http"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.default.id
}
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-content-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}
