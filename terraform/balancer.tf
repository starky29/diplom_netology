# Создание групп целей для балансировщика нагрузки
resource "yandex_lb_target_group" "k8s-worker-cluster" {
  depends_on = [yandex_compute_instance.worker]
  name = "k8s-worker-cluster"
  dynamic "target" {
    for_each = yandex_compute_instance.worker
    content {
      subnet_id = target.value.network_interface[0].subnet_id
      address   = target.value.network_interface[0].ip_address
    }
  }
}
#Создание сетевого балансировщика
resource "yandex_lb_network_load_balancer" "k8s" {
  name = "k8s-balancer"
  listener {
    name        = var.listener_web_app.name
    port        = var.listener_web_app.port
    target_port = var.listener_web_app.target_port

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s-worker-cluster.id
    healthcheck {
      name = "tcp"
      tcp_options {
        port = 22

      }
    }
  }
}

resource "yandex_lb_network_load_balancer" "k8sgrafana" {
  depends_on = [yandex_lb_network_load_balancer.k8s]
  name = "grafana-k8s-balancer"
  listener {
    name        = var.listener_grafana.name
    port        = var.listener_grafana.port
    target_port = var.listener_grafana.target_port

    external_address_spec {
      ip_version = "ipv4"
    }
  }


  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s-worker-cluster.id
    healthcheck {
      name = "tcp"
      tcp_options {
        port = 22

      }
    }
  }
}