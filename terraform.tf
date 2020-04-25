variable "do_token" {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}

provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  version = "~> 1.0"
  email = var.cloudflare_email
  token = var.cloudflare_token
}


data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}

resource "digitalocean_droplet" "rancher" {
  image  = "docker-18-04"
  name   = "rancher"
  region = "fra1"
  size   = "s-4vcpu-8gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]

  connection {
    user        = "root"
    type        = "ssh"
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "docker run -q --name rancher -d --restart=always -p 80:80 -p 443:443 rancher/rancher:latest --acme-domain rancher.sikademo.com",
    ]
  }
}

resource "cloudflare_record" "droplet" {
  domain = "sikademo.com"
  name   = "rancher"
  value  = digitalocean_droplet.rancher.ipv4_address
  type   = "A"
  proxied = false
}
