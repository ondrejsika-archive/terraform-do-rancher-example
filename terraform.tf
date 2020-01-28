variable "do_token" {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}

variable "vm_count" {
  default = 1
}

provider "digitalocean" {
  token = "${var.do_token}"
}

provider "cloudflare" {
  version = "~> 1.0"
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}


data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}

resource "digitalocean_droplet" "droplet" {
  count = var.vm_count

  image  = "docker-18-04"
  name   = "droplet"
  region = "fra1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
}

resource "cloudflare_record" "droplet" {
  count = var.vm_count

  domain = "sikademo.com"
  name   = "droplet${count.index}"
  value  = "${digitalocean_droplet.droplet[count.index].ipv4_address}"
  type   = "A"
  proxied = false
}


resource "cloudflare_record" "droplet_wildcard" {
  count = var.vm_count

  domain = "sikademo.com"
  name   = "*.droplet${count.index}"
  value  = "droplet${count.index}.sikademo.com"
  type   = "CNAME"
  proxied = false
}
