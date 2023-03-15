# -- security/main.tf

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair"
  public_key = tls_private_key.my_key_pair.public_key_openssh
}

resource "tls_private_key" "my_key_pair" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  content  = tls_private_key.my_key_pair.private_key_pem
  filename = "my_key_pair.pem"
}

resource "aws_security_group" "my_security_group" {
  name = "my_security_group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.my_ip_address #["${var.my_ip_address}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.my_ip_address #["${var.my_ip_address}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "chmod_private_key" {
  depends_on = [local_file.private_key]

  provisioner "local-exec" {
    command = "chmod 400 ${local_file.private_key.filename}"
  }
}