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

variable "github_token" {
  type    = string
}
variable "webhook_token" {
  type    = string
}
variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "vpc_name" {
  description = "Имя виртуальной сети"
  type        = string
  default     = "vpc"
}
