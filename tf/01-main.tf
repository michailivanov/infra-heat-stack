terraform {
  # Минимальная требуемая версия Terraform
  required_version = ">= 0.14.0"
  
  # Настройка необходимых провайдеров
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"  # Источник провайдера
      version = "~> 1.39.0"  # Версия провайдера (примерно 1.39.0)
    }
  }
}


# use environment variables
# https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs
provider "openstack" {
  auth_url = "https://cloud.crplab.ru:5000"
  tenant_id = "a02aed7892fa45d0bc2bef3b8a08a6e9" # ID проекта
  tenant_name = "students"
  user_domain_name = "Default"
  # export TF_VAR_user_name=
  user_name = var.user_name
  # export TF_VAR_password=
  password = var.password
  region = "RegionOne"
}

# https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_v2
resource "openstack_networking_secgroup_v2" "sg" {
  name = "ivanov-group-trfm"
}

# https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_rule_v2
resource "openstack_networking_secgroup_rule_v2" "sg_ssh_rule" {
  direction = "ingress" # Направление трафика (входящий)
  ethertype = "IPv4" 
  protocol = "tcp"
  port_range_min = 22
  port_range_max = 22
  remote_ip_prefix = "0.0.0.0/0" # Доступ с любых IP-адресов
  security_group_id = openstack_networking_secgroup_v2.sg.id
}

# https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2
resource "openstack_compute_instance_v2" "ivanov_server" {
  name = "ivanov-server-trfm"
  image_name = var.image_name
  flavor_name = var.server_flavor
  key_pair = var.key_pair
  security_groups = [openstack_networking_secgroup_v2.sg.name]

  network {
    name = var.network_name
  }
}

# https://github.com/diodonfrost/terraform-openstack-examples
