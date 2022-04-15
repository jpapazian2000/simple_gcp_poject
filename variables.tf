variable "region" {
  description = "gcp region"
  default     = "europe-west1"
}

variable "zone" {
  description = "gcp zone"
  default     = "europe-west1-b"
}

variable "project" {
  description = "gcp project"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
