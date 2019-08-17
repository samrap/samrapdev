provider "digitalocean" {
  token = "${var.do_token}"

  spaces_access_id  = "${var.do_spaces_access_id}"
  spaces_secret_key = "${var.do_spaces_secret_key}"
}

resource "digitalocean_ssh_key" "default" {
  name       = "sam_rapaport_macbook_pro"
  public_key = "${file("/Users/sam/.ssh/id_rsa.pub")}"
}

resource "digitalocean_spaces_bucket" "samrapdev-backups" {
  name   = "samrapdev-backups"
  region = "${var.region}"
  acl    = "private"
}

resource "digitalocean_tag" "firewall_webserver" {
  name = "firewall:webserver"
}

resource "digitalocean_firewall" "webserver" {
  name = "webserver"

  tags = ["firewall:webserver"]

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "80"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "443"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "icmp"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "53"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "udp"
      port_range              = "53"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "tcp"
      port_range              = "80"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "tcp"
      port_range              = "443"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "icmp"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]
}
