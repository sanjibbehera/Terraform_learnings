resource "random_id" "instance_id" {
  byte_length = 8
}

provider "google" {
 credentials = "${file("SANJIB Project-29e10befe789.json")}"
 project     = "ace-daylight-256904"
 region      = "asia-south1-c"
}

resource "google_compute_instance" "default" {
  name         = "vm-${random_id.instance_id.hex}"
  machine_type = "n1-standard-1"
  zone         = "asia-south1-c"

  boot_disk {
    initialize_params {
      image = "centos-8-v20191121"
    }
  }
  
  metadata_startup_script = "sudo yum -y update && sudo yum install apache2 -y && echo '<!doctype html><html><body><h1>Hello from Terraform on Google Cloud!</h1></body></html>' | sudo tee /var/www/html/index.html"
  
  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  // Apply the firewall rule to allow external IPs to access this instance
  tags = ["http-server"]
}

resource "google_compute_firewall" "http-server" {
  name    = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  // Allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
