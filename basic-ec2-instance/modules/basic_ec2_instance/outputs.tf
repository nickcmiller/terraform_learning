# -- basic_ec2_instance/outputs.tf

output "public_ip" {
  value       = aws_instance.basic_ec2_instance.public_ip
  description = "The public IP of the basic_ec2_instance"
}
