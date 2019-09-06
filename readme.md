Provisioning setup for my Ghost CMS blog.

| URL | Platform | Host |
| --- | --- | --- |
| [https://samrapdev.com](https://samrapdev.com) | [Ghost CMS](https://ghost.org/) | [Digital Ocean](https://www.digitalocean.com/) |

## About

My blog is currently run on the [Ghost CMS](https://ghost.org/) platform using the [ghost Docker image](https://hub.docker.com/_/ghost) on a standard Digital Ocean droplet. This repository contains the codified infrastructure and provisioning steps for bootstrapping a fully-functional instance of the blog.

As mentioned, the platform runs inside the official ghost Docker image. However, there is a lot more that goes into running this image in a safe, modern, and reliable production environment. The image runs on a Digital Ocean droplet, which must be provisioned to run the Docker image, terminate TLS and foreward traffic to it, manage and backup state, and more. This may seem like a one-time setup, but in actuality it's good practice to regularly cycle out infrastructure to ensure the latest software updates and to exercise the bootstrapping path of your website or application. However, performing these steps manually is prone to error and takes time even for something seemingly simply like a Ghost CMS blog. These steps are documentable, which means they are automatable!

[Terraform](https://www.terraform.io/) is used to manage the infrastructure as code – that is, the storage, firewalls, floating IPs, and the droplet that serve as the infrastructure running the blog. [Ansible](https://docs.ansible.com/ansible/latest/index.html) is used to configure the droplet and deploy the software that runs it. This combines into just several commands that together are capable of reliably bootstrapping the blog from nothing but an S3 or Digital Ocean [Spaces](https://www.digitalocean.com/docs/spaces/) backup.

## How it works

Provisioning and deployment of the blog is broken into _tiers_. Tiers are logical groupings of steps that, when performed in order, provide a running instance of the blog. Each tier provides a critical piece of infrastructure and/or configuration.

| Tier | Name | Description |
| --- | --- | --- |
| 0 | Base tier | SSH keys, [Spaces](https://www.digitalocean.com/docs/spaces/), tags, and firewalls that persist across blog instances |
| 1 | Droplet tier | Droplet creation and critical provisioning |
| 2 | Bootstrap tier | Full configuration of the droplet and bootstrapping of the blog |
| 3 | Deployment tier | Points [Floating IP](https://www.digitalocean.com/docs/networking/floating-ips/) to new droplet |

---

**Note:** This setup requires that a DNS and single floating IP be created manually in the Digital Ocean web console. This is the only manual set up required prior to provisioning. Everything else is managed by this repository.

---

### Base tier

The Base tier, `tier0`, only needs to be provisioned once upon project or account creation. It provides the SSH keys, tags, and firewalls that are shared between any instance of the blog. Additionally, it creates a Digital Ocean Space that is used for backup and restoration.

### Droplet tier

The Droplet tier, `tier1`, is run when spinning up a new droplet. This will be done initially to run the blog and subsequently to swap out the underlying droplet. It contains a [cloud-init](https://cloud-init.io/) script that runs the minimal provisioning of the droplet such that it is safely configured for SSH access which is required to run the following tier. Specifically, the cloud-init script creates a non-root user, locks down SSH access, and ensures that authentication uses the Base tier SSH keys.

### Bootstrap tier

The Bootstrap tier, `tier2`, should always be run after and in conjunction with the Droplet tier. It uses Ansible to apply the host's configuration, install required packages, restore stateful backups (such as the blog's database and SSL certs), install crons, and finally start up the Docker service. After running the Bootstrap tier, the blog is ready to begin accepting secure HTTPS traffic.

The Bootstrap tier is idempotent and can be run on already-bootstrapped hosts. Once use-case for this is updating the Ghost version by downloading the latest Docker image. However, this is also a great candidate for just provisioning a brand new droplet by running tiers 1-3!

### Deployment tier

The Deployment tier, `tier3`, is the final tier for provisioning the blog. It simply points the Digital Ocean Floating IP address to the newly created droplet by asking for the name given to the droplet in the Droplet tier. Assuming DNS is managed by Digital Ocean and points to that IP, users connecting to [samrapdev.com](https://samrapdev.com) will at that point be connecting to the newly provisioned droplet. At this point, it is safe to destroy the previous droplet.

## Future work

- [ ] Add documentation for running the tiers
- [ ] Remove hardcoded variables from Ansible
