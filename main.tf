  # Configure the DigitalOcean provider
provider "digitalocean" {
  token = var.do_token
}

# Define the DigitalOcean Droplet resource

resource "digitalocean_droplet" "bitwarden" {
  name      = "bitwarden"
  image     = "ubuntu-20-04-x64"
  region    = var.region
  size      = "s-1vcpu-2gb"
  ssh_keys  = [digitalocean_ssh_key.example.fingerprint]

  provisioner "local-exec" {
    command = "ssh-keygen -lf ${var.public_key_path} | awk '{print $2}'"
    environment = {
      PATH = "/usr/bin:/usr/local/bin"
    }

    on_failure = "error"
    on_success = "continue"
    interpreter = ["bash", "-c"]
    
    vars = {
      public_key_path = var.public_key_path
    }
  
    # Store the output of the command in the 'ssh_fingerprint' output variable
    # that can be used by other resources
    # (Note: This assumes the command output is a valid SSH fingerprint)
    # See https://www.ssh.com/ssh/keygen/ for more information on SSH fingerprints.
    outputs = ["ssh_fingerprint"]
  }

}

output "ssh_fingerprint" {
  value = digitalocean_droplet.bitwarden.provisioner.0.output["ssh_fingerprint"]
}

  # Copy the public SSH key to the Droplet
  provisioner "file" {
    source = var.public_key_path
    destination = "/root/.ssh/authorized_keys"
    connection {
      type = "ssh"
      user = "root"
      private_key = file(var.private_key_path)
      timeout = "2m"
      host = self.ipv4_address
    }
  }

  # Update the Ubuntu operating system, install Docker and Docker Compose
  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get install -y docker.io docker-compose",
    ]
  }
}
