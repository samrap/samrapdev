# samrapdev-ghost

WIP repository for provisioning an instance of [samrapdev.com](https://samrapdev.com).

The Digital Ocean hosted website is provisioned in tiers. A breakdown of tiers is as follows:

- **tier0:** Base Terraform modules. Provisions SSH keys, tags, and firewalls
- **tier1:** Provisions the droplet. Includes Terraform modules for creating the droplet and an Ansible playbook for provisioning the host. Provisioning the host includes spinning up the Ghost CMS and database via docker-compose. After running tier1, you can navigate to the site using the IP address.
- **tier2: (TODO)** The final tier. Moves Digital Ocean hosted DNS name to the new IP address. Deletes the old droplet (if applicable)

## TODO

- [ ] Provision certbot certs and auto-renewal as part of tier1
- [ ] Sync Ghost data volumes from backups
- [ ] Better droplet replacement automation
- [ ] tier2
