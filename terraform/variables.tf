variable "cloud_id" {
  type = string
  sensitive = true
}

variable "folder_id" {
  type = string
  sensitive = true
}

variable "token" {
  type = string
  sensitive = true
}

variable "ssh_key" {
  description = "ssh public key"
  type        = string
  sensitive = true
}

variable "bucket" {
  type        = string
  description = "bucket name"
} 

variable "access_key" {
  type        = string
  description = "access_key"
}

variable "secret_key" {
  type        = string
  description = "secret_key"
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "vpc_name" {
  description = "Имя виртуальной сети k8s"
  type        = string
  default     = "k8s-network"
}

variable "subnet_zone" {
  type        = list(string)
  description = "Список зон"
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "cidr" {
  type        = list(string)
  description = "Список CIDR-ов"
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}
variable "cidr_bastion" {
  type        = list(string)
  description = "bastion net"
  default     = ["10.1.0.0/24"]
}

variable "master" {
  type        = map(any)
  description = "Описание ресурсов для master нод"

}

variable "worker" {
  type        = map(any)
  description = "Описание ресурсов для worker нод"
}

variable "bastion" {
  type        = map(any)
  description = "Описание ресурсов для bastion нод"

}

variable "listener_grafana" {
  type        = map(any)
  description = "Описание параметров listener для grafana"
}
variable "listener_web_app" {
  type        = map(any)
  description = "Описание параметров listener для web-приложения"
}
variable "counts_masters" {
  type = number
  default = 1
}
variable "counts_workers" {
  type = number
  default = 2
}
