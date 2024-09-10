provider "aws" {
  region = var.region
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name = "my-generated-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "web" {
  ami = "ami-0cdfcb9783eb43c45"
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated_key.key_name

  tags = {
    "Name" = "NginxServer"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "[webserver]" > inventory.txt
      echo "${self.public_ip}" >> inventory.txt
    EOT
  }

  vpc_security_group_ids = [aws_security_group.web_sg.id]
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web_sg"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}