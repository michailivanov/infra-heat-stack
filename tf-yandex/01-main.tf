# Блок Terraform с настройками требуемых провайдеров и версии
terraform {
  # Блок required_providers указывает, какие провайдеры необходимы
  required_providers {
    yandex = {
      # Используем официальный провайдер Yandex Cloud
      source = "yandex-cloud/yandex"
    }
  }
  # Минимальная требуемая версия Terraform
  required_version = ">= 0.13"
}

# Настройка провайдера Yandex Cloud
provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}

# Создание загрузочного диска для виртуальной машины
resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"                  # Имя диска
  type     = "network-hdd"                  # Тип диска (сетевой HDD)
  zone     = "ru-central1-a"                # Зона размещения
  size     = "20"                           # Размер диска в GB
  image_id = "fd833v6c5tb0udvk4jo6"         # ID образа (Ubuntu 22.04 LTS)
}

# Создание виртуальной машины
resource "yandex_compute_instance" "vm-1" {
  name = "kondraev-terraform"               # Имя ВМ

  # Ресурсы ВМ
  resources {
    cores  = 2  # Количество ядер (допустимые значения: 2,4,6,8,10,12,14,16,20,24,28,32)
    memory = 2  # Объем памяти в GB
  }

  # Загрузочный диск
  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id  # Используем созданный ранее диск
  }

  # Сетевой интерфейс
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id  # Подключаем к созданной подсети
    nat       = true                           # Включаем NAT для выхода в интернет
  }

  # Метаданные ВМ
  metadata = {
    user-data = "${file("meta.txt")}"  # Загружаем пользовательские данные из файла meta.txt
                                      # (обычно содержит cloud-init конфигурацию)
  }
}

# Создание облачной сети
resource "yandex_vpc_network" "network-1" {
  name = "network1"  # Имя сети
}

# Создание подсети в сети
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"                     # Имя подсети
  zone           = "ru-central1-a"               # Зона размещения
  network_id     = yandex_vpc_network.network-1.id  # ID родительской сети
  v4_cidr_blocks = ["192.168.10.0/24"]           # Диапазон IP-адресов подсети
}

# Создание группы безопасности
resource "yandex_vpc_security_group" "group1" {
  name        = "mhq-security-group"            # Имя группы безопасности
  network_id  = yandex_vpc_network.network-1.id # ID сети, к которой привязана группа
}

# Создание правила в группе безопасности для SSH
resource "yandex_vpc_security_group_rule" "ssh-rule" {
  security_group_binding = yandex_vpc_security_group.group1.id  # ID группы безопасности
  direction              = "ingress"             # Входящий трафик
  description            = "mhq ssh"            # Описание правила
  v4_cidr_blocks         = ["0.0.0.0/32"]       # Разрешенные IP-адреса (0.0.0.0/32 означает фактически "ничего")
  port                   = 22                   # Порт SSH
  protocol               = "TCP"                # Протокол TCP
}

# Вывод внутреннего IP-адреса созданной ВМ
output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

# Вывод внешнего IP-адреса созданной ВМ
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

# Вывод информации о серверах в виде map
output "servers" {
  value = {
    serverip = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address  # Внешний IP сервера
  }
}
