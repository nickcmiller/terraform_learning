variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
}

variable "key_pair_name" {
  description = "The name of the key pair"
  type        = string
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "basic_ec2_instance" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "basic_ec2_instance"
  }
}

output "public_ip" {
  value       = aws_instance.basic_ec2_instance.public_ip
  description = "The public IP of the basic_ec2_instance"
}
