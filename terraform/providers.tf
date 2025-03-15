provider "yandex" {
  cloud_id  = var(YC_CLOUD_ID)
  folder_id = var(YC_FOLDER_ID)
  token     = var(YC_TOKEN)
  zone      = var.zone
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
    bucket     = var.bucket
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
