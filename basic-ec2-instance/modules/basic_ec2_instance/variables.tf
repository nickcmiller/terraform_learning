# -- basic_ec2_instance/variables.tf

variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
}

variable "key_pair_name" {
  description = "The name of the key pair"
  type        = string
}
