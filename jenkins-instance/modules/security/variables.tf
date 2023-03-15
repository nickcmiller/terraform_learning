# -- security/variables.tf

variable "my_ip_address" {
  description = "IP address(es) that will be able to access your instance"
  type        = list(any)
}