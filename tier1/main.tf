provider "digitalocean" {
  token = "${var.do_token}"
}

data "digitalocean_ssh_key" "sam_rapaport_macbook_pro" {
  name = "sam_rapaport_macbook_pro"
}

data "local_file" "cloud_init" {
  filename = "${path.module}/cloud-init.yml"
}

resource "digitalocean_droplet" "samrapdev" {
  image  = "${var.image}"
  name   = "${var.name}"
  region = "${var.region}"
  size   = "${var.size}"
  ssh_keys = ["${data.digitalocean_ssh_key.sam_rapaport_macbook_pro.id}"]
  tags = ["firewall:webserver", "type:samrapdev"]

  user_data = "${data.local_file.cloud_init.content}"
}
