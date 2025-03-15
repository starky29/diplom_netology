vpc_name    = "VPC-k8s"

master = {
  cores             = 4,
  memory            = 4,
  core_fraction     = 20,
  platform_id       = "standard-v3",
  count             = 1,
  image_id          = "fd8slhpjt2754igimqu8",
  disk_sze          = 40,
  scheduling_policy = "true"
}

worker = {
  cores             = 4,
  memory            = 4,
  core_fraction     = 20,
  platform_id       = "standard-v3",
  count             = 2,
  image_id          = "fd8slhpjt2754igimqu8",
  disk_sze          = 40,
  scheduling_policy = "true"
}

bastion = {
  cores             = 2,
  memory            = 2,
  core_fraction     = 20,
  image_id          = "fd8m30o437b5c6b9en6r",
  disk_sze          = 20,
  scheduling_policy = "true"
}
listener_grafana = {
  name        = "grafana-listener"
  port        = 80
  target_port = 30300
}

listener_web_app = {
  name        = "web-listener-app"
  port        = 80
  target_port = 30080
}
