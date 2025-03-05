resource "local_file" "inventory" {
    depends_on = [yandex_compute_instance.master, yandex_compute_instance.worker, yandex_compute_instance.bastion-nat]
    filename = "../ansible/hosts.yml"
    content = templatefile("inventory.tftpl", {
        masters = (yandex_compute_instance.master),
        workers = (yandex_compute_instance.worker),
        bastion = yandex_compute_instance.bastion-nat
    })
}