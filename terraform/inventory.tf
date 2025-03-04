resource "local_file" "inventory" {
    depends_on = [yandex_compute_instance.master, yandex_compute_instance.worker, yandex_compute_instance.bastion-nat]
    filename = "../ansible/hosts.yml"
    content = templatefile("./inventory.tftpl", {
        master = [yandex_compute_instance.master],
        worker = [andex_compute_instance.worker],
        balancer = [yandex_compute_instance.bastion-nat]
    })
}