# Standard_D2_v2 = 2 CPU 7 GB - Master
# Standard_D1_v2 = 1 CPU 3.5 GB - Worker y NFS

variable "vm_size_master" {
  type = string
  description = "Flavour de la máquina virtual Master"
  default = "Standard_D2_v2"
}

variable "vm_size_worker" {
  type = string
  description = "Flavour de la máquina virtual Master"
  default = "Standard_D1_v2"
}


variable "vm_workers" {
  type = list(string)
  description = "Máquinas worker"
  default = ["worker01", "worker02"]
}
