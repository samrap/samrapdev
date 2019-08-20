data "digitalocean_droplet" "samrapdev" {
  name = "${var.droplet_name}"
}

resource "digitalocean_floating_ip_assignment" "samrapdev" {
  ip_address = "${var.floating_ip_address}"
  droplet_id = "${data.digitalocean_droplet.samrapdev.id}"
}
