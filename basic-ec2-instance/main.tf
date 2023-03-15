#  -- root/main.tf

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  current_ip = chomp(data.http.my_ip.body)
}

module "security" {
  source = "./modules/security"
  my_ip_address = local.current_ip
}

module "basic_ec2_instance" {
  source = "./modules/basic_ec2_instance"
  security_group_id = module.security.security_group_id
  key_pair_name     = module.security.key_pair_name
}

output "ssh_command" {
  value = format("ssh -i %s ec2-user@%s", module.security.private_key_file, module.basic_ec2_instance.public_ip)
  description = "The SSH command to connect to the basic_ec2_instance"
}