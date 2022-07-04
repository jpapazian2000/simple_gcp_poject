terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.27.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "${var.prefix}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
    name = "${var.prefix}-subnet"
    region = var.region
    network = google_compute_network.vpc_network.self_link
    ip_cidr_range = var.subnet_prefix
}

resource "google_compute_firewall" "ssh_access" {
  name = "${var.prefix}-allow-ssh"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = [var.allowed_ip]
  source_tags = ["ssh-access"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  } 
  labels = {
    owner = var.owner
    se-region = var.se-region
    purpose = var.purpose
    ttl = var.ttl
    terraform = var.terraform
    hc-internet-facing = var.hc-internet-facing
    billing = "test"
    department = "dev"
  } 
  

  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnetwork.self_link
    access_config {
    }
  }
  tags = ["ssh-access"]
  metadata = {
        sshKeys = "${var.ssh_user}:${var.ssh_keys}"
    }
}


