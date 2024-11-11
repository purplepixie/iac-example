provider "google" {
 credentials = file("servicekey.json")
 project = "csc3065-2425"
 region = "us-west1"
}

resource "random_id" "instance_id" {
 byte_length = 8
}

resource "google_compute_instance" "default" {
 name = "flask-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone = "us-west1-a"

 boot_disk {
  initialize_params {
    image = "ubuntu-2204-lts"
  }
 }

 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

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
