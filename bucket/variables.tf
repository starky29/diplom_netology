variable "cloud_id" {
  description = "ID облака"
  type        = string

}
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"

}
variable "folder_id" {
  description = "ID папки"
  type        = string

}

variable "ssh_public_key" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}
variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_public_key_path" {
  description = "Путь к публичному SSH ключу"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "vpc_name" {
  description = "Имя виртуальной сети"
  type        = string
  default     = "vpc"
}

variable "subnet_public_name" {
  description = "Имя публичной подсети"
  type        = string
  default     = "public"
}

variable "subnet_private_name" {
  description = "Имя приватной подсети"
  type        = string
  default     = "private"
}
variable "default_zone" {
  default = "ru-central1-a"
}