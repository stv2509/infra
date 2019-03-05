variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable sshuser {
  description = "SSH USER"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-1551564810"
}
