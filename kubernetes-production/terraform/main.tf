provider "google" {
  project = "first-scarab-312616"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "master" {
  name         = "master"
  machine_type = "n1-standard-2"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {}
  }
  metadata_startup_script = templatefile("master.tpl", {})
  metadata = {
   sshKeys = "root:${file(var.ssh_public_key_filepath)}"
 }
}
resource "google_compute_instance" "worker1" {
  name         = "worker1"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {}
  }
  metadata_startup_script = templatefile("workers.tpl", {})
  metadata = {
   sshKeys = "root:${file(var.ssh_public_key_filepath)}"
 }
}
resource "google_compute_instance" "worker2" {
  name         = "worker2"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {}
  }
  metadata_startup_script = templatefile("workers.tpl", {})
  metadata = {
   sshKeys = "root:${file(var.ssh_public_key_filepath)}"
 }
}
resource "google_compute_instance" "worker3" {
  name         = "worker3"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {}
  }
  metadata_startup_script = templatefile("workers.tpl", {})
  metadata = {
   sshKeys = "root:${file(var.ssh_public_key_filepath)}"
 }
}
