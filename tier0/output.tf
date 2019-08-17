output "samrapdev_backups_bucket_domain_name" {
  value = "${digitalocean_spaces_bucket.samrapdev-backups.bucket_domain_name}"
}
