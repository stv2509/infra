variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable sshuser {
  description = "SSH USER"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-1551563575"
}
