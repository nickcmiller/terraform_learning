# -- security/outputs.tf

output "security_group_id" {
  value = aws_security_group.my_security_group.id
}

output "key_pair_name" {
  value = aws_key_pair.my_key_pair.key_name
}

output "private_key_file" {
  value       = local_file.private_key.filename
  description = "The path to the private key file"
}
