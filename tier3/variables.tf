variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

variable "droplet_name" {}

variable "floating_ip_address" {
  default = "157.230.198.148"
}
