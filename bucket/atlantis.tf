#настройка атлантис сервера
resource "yandex_vpc_network" "atlantis" {
  name = var.vpc_name
}
# Создание подсетей
resource "yandex_vpc_subnet" "subnets" {
  zone            = var.zone
  name            = "subnets_atlantis"
  network_id      = yandex_vpc_network.atlantis.id
  v4_cidr_blocks  = ["10.2.0.0/24"]
}

resource "yandex_compute_instance" "atlantis" {
  name = "atlantis"
  zone = var.zone

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8slhpjt2754igimqu8"
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnets.id
    nat                = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "ubuntu:${var.ssh_public_key}"
    user-data = <<-EOF
                users:
                - name: ubuntu
                  groups: sudo
                  shell: /bin/bash
                  sudo: ["ALL=(ALL) NOPASSWD:ALL"]
                #cloud-config
                runcmd:
                  sudo apt -y install unzip
                  wget https://github.com/runatlantis/atlantis/releases/latest/download/atlantis_linux_amd64.zip
                  unzip atlantis_linux_amd64.zip
                  chmod +x atlantis
                  sudo mv atlantis /usr/local/bin/
                  wget https://hashicorp-releases.yandexcloud.net/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip
                  unzip terraform_1.8.5_linux_amd64.zip
                  sudo mv terraform /usr/local/bin/
                  atlantis server \
                    --atlantis-url=http://localhost:4141 \
                    --gh-webhook-secret="${var.webhook_token}"\
                    --gh-user=starky29 \
                    --gh-token="${var.github_token}"\
                    --repo-allowlist="starky29/diplom_netology/bucket"\
                    --default-tf-version="1.8.5"
                EOF
  }
  scheduling_policy {
    preemptible = true
  }

}
