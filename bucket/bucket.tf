resource "yandex_iam_service_account" "sa" {
  name = "sa-for-bucket"
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
}

# Создание бакета с использованием ключа
resource "yandex_storage_bucket" "tstate" {
  access_key    = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket        = "bucket-starkov-2025"
  acl           = "private"
  force_destroy = true

}
# Создание файла конфигурации для подключения бэкэнда terraform к S3
resource "local_file" "backend" {
  content  = <<EOT
provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
  token     = var.token
}
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket     =  var.bucket
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = var.access_key
    secret_key = var.secret_key

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
  }
EOT
  filename = "../terraform/providers.tf"

}
# Создание файла переменных для подключения бэкэнда terraform к S3
resource "local_file" "auto_tfvars" {
  content  = <<EOT
bucket     = "bucket-starkov-2025"
access_key = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
secret_key = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
EOT
  filename = "../terraform/bucket.auto.tfvars"

}