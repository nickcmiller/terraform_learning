#  -- root/main.tf

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

#Use this if running on Terraform on a server IDE but you want to be able to access instance from personal computer
#Run "export TF_VAR_my_second_ip_address=<computer IP address>" 
variable "my_second_ip_address" {
  description = "Conditionally add a second IP address with a TF_VAR"
  type        = string
  default     = ""
}

locals {

  #pull address of the machine Terraform is being run on
  current_ip = chomp(data.http.my_ip.response_body)

  #add the address of machine running TF and an optional second address
  cidr_blocks = [
    "${local.current_ip}/32",
    var.my_second_ip_address != "" ? "${var.my_second_ip_address}/32" : null
  ]
}

module "security" {
  source        = "./modules/security"
  my_ip_address = local.cidr_blocks
}

module "basic_ec2_instance" {
  source            = "./modules/basic_ec2_instance"
  security_group_id = module.security.security_group_id
  key_pair_name     = module.security.key_pair_name
}

output "ssh_command" {
  value       = format("ssh -i %s ec2-user@%s", module.security.private_key_file, module.basic_ec2_instance.public_ip)
  description = "The SSH command to connect to the basic_ec2_instance"
}