variable "do_token" {
  type        = string
  description = "DigitalOcean API token"
}

variable "image" {
  type        = string
  description = "The image used for the Droplet"
  default     = "ubuntu-20-04-x64"
}

variable "droplet_name" {
  type        = string
  description = "The name of the Droplet"
}

variable "region" {
  type        = string
  description = "The region to create the Droplet in"
  default     = "lon1"
}

variable "droplet_size" {
  type        = string
  description = "The size of the Droplet"
  default     = "s-1vcpu-1gb"
}

variable "ssh_fingerprint" {
  type = string
  description = "The fingerprint of the SSH key to use for authentication"
}

variable "private_key_path" {
  type = string
  description = "The path to the private key file used for authentication"
}

variable "public_key_path" {
  type = string
  description = "The path to the public key file to be copied to the Droplet"
}