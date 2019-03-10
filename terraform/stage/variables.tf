variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable private_key {
  description = "Connection private_key"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable sshuser {
  description = "SSH USER"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-ansible-1552152319"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-ansible-1551875383"
}
