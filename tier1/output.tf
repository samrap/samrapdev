output "id" {
  value = "${digitalocean_droplet.samrapdev.id}"
}

output "name" {
  value = "${digitalocean_droplet.samrapdev.name}"
}

output "address" {
  value = "${digitalocean_droplet.samrapdev.ipv4_address}"
}

output "message" {
  value = "Droplet created. It may take several minutes before SSH access is available."
}
