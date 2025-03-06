resource "yandex_compute_instance" "bastion-nat" {

  name                      = "bastion-nat"
  allow_stopping_for_update = true
  resources {
    cores         = var.bastion.cores
    memory        = var.bastion.memory
    core_fraction = var.bastion.core_fraction

  }
  scheduling_policy {
    preemptible = var.bastion.scheduling_policy

  }
  boot_disk {

    initialize_params {
      image_id = var.bastion.image_id
      size     = var.bastion.disk_sze
    }

  }
  network_interface {

    subnet_id          = yandex_vpc_subnet.bastion-nat.id
    security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
    nat                = true
  }
  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${var.ssh_key}" 
    user-data          =     <<-EOT
    users:
    - name: ubuntu
      groups: sudo
      shell: /bin/bash
      sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    runcmd:
      sudo apt update
     EOT
  }
}
##########################master########################################
resource "yandex_compute_instance" "master" {

  count = var.counts_masters

  allow_stopping_for_update = true
  zone                      = var.subnet_zone[count.index]
  platform_id               = var.worker.platform_id
  hostname                  = "k8s-master-${count.index + 1}"
  name                      = "k8s-master-${count.index + 1}"

  resources {
    cores         = var.master.cores
    memory        = var.master.memory
    core_fraction = var.master.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.master.image_id
      size     = var.master.disk_sze
    }
  }


  scheduling_policy {
    preemptible = var.master.scheduling_policy
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${var.ssh_key}" 
    user-data          =     <<-EOT
    users:
    - name: ubuntu
      groups: sudo
      shell: /bin/bash
      sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    runcmd:
      sudo apt update
     EOT
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnets[var.subnet_zone[count.index]].id
    security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
  }
}
###########################workers########################################
resource "yandex_compute_instance" "worker" {

  count = var.counts_workers
  

  allow_stopping_for_update = true
  zone                      = var.subnet_zone[count.index]
  
  platform_id               = var.worker.platform_id
  hostname                  = "k8s-worker-${count.index + 1}"
  name                      = "k8s-worker-${count.index + 1}"

  resources {
    cores         = var.worker.cores
    memory        = var.worker.memory
    core_fraction = var.worker.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.worker.image_id
      size     = var.worker.disk_sze
    }
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${var.ssh_key}" 
    user-data          =     <<-EOT
    users:
    - name: ubuntu
      groups: sudo
      shell: /bin/bash
      sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    runcmd:
      sudo apt update
     EOT
  }

  scheduling_policy {
    preemptible = var.worker.scheduling_policy
  }

  
  network_interface {
    subnet_id          = yandex_vpc_subnet.subnets[var.subnet_zone[count.index]].id
    security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
  }
}
########################################################################
