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
resource "yandex_compute_disk" "boot-disk-ivanov" {
  name     = "boot-disk-ivanov"                  # Имя диска
  type     = "network-hdd"                  # Тип диска (сетевой HDD)
  zone     = "ru-central1-a"                # Зона размещения
  size     = "20"                           # Размер диска в GB
  image_id = "fd833v6c5tb0udvk4jo6"         # ID образа (Ubuntu 22.04 LTS)
}

# Создание виртуальной машины
resource "yandex_compute_instance" "vm-1" {
  name = "ivanov-terraform"               # Имя ВМ

  # Ресурсы ВМ
  resources {
    cores  = 2  # Количество ядер (допустимые значения: 2,4,6,8,10,12,14,16,20,24,28,32)
    memory = 2  # Объем памяти в GB
  }

  # Загрузочный диск
  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-ivanov.id  # Используем созданный ранее диск
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

# Получение данных о существующей сети
data "yandex_vpc_network" "existing" {
  name = "default" 
}

# Создание подсети
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "ivanov-subnet"
  zone           = "ru-central1-a"
  network_id     = data.yandex_vpc_network.existing.id  # Используем полученный ID сети
  v4_cidr_blocks = ["192.168.60.0/24"]     # Диапазон свободен
}

# Группа безопасности (корректно)
resource "yandex_vpc_security_group" "group1" {
  name        = "ivanov-security-group"
  network_id  = data.yandex_vpc_network.existing.id
  description = "Security group for Ivanov VM" 
}

# Правило SSH
resource "yandex_vpc_security_group_rule" "ssh-rule" {
  security_group_id = yandex_vpc_security_group.group1.id 
  direction         = "ingress"
  description       = "Allow SSH to Ivanov VM"
  protocol          = "TCP"
  port              = 22
  v4_cidr_blocks    = ["0.0.0.0/0"]  # Разрешаем SSH со всех IP.
}

# Вывод IP-адресов
output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

# Вывод информации о серверах в виде map
output "servers" {
  value = {
    serverip = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address  # Внешний IP сервера
  }
}
