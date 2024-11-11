provider "google" {
 credentials = file("servicekey.json")
 project = "csc3065-2425"
 region = "us-west1"
}

resource "random_id" "instance_id" {
 byte_length = 8
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-rule"
  network = "default"
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }
  target_tags = ["allow-http"]
  priority    = 1000
  source_ranges = ["0.0.0.0/0"]

}

resource "google_compute_instance" "default" {
 name = "web-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone = "us-west1-a"
 tags = ["http-server","allow-http"]

 boot_disk {
  initialize_params {
    image = "ubuntu-2204-lts"
  }
 }

 metadata_startup_script = "sudo apt-get update"

 network_interface {
  network = "default"

  access_config {
  }
 }

 metadata = {
  ssh-keys = "dcutting:${file("~/.ssh/id_rsa.pub")}"
 }
}

output "ip" {
 value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
