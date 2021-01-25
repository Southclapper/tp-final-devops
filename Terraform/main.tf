
provider "aws" {
  region     = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Resources for default vpc aws
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default vpc for aws instances"
  }
}

#Create aws ec2 Instance
resource "aws_instance" "web" {
  count         = var.create_instance ? var.instance_number : 0
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name        = var.sshKey
  vpc_security_group_ids = [aws_security_group.allow_ssh_thibault.id]

 provisioner "local-exec" {
     command = "rm -rf ansible/hosts"
  }

 provisioner "local-exec" {
    command = <<EOT
	echo "[server]" | tee -a ansible/hosts;
	echo "${aws_instance.web[count.index].public_ip}" | tee -a ansible/hosts;
    EOT
  }
 
# provisioner "local-exec" {
#   command = "ansible-playbook --private-key=${var.sshKey} -i ansible/hosts ansible/playbook.yml"
# }

  tags = {
    Name = var.instance_name
  }
}

# Create a Security Group
resource "aws_security_group" "allow_ssh_thibault" {
  name        = "allow_http_ssh_thibault"
  description = "Allow SSH for incomming traffic"
  
   ingress {
    description = "Http server web"
    from_port = var.http_port
    to_port   = var.http_port
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Port"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "var.security_group"
  }
}

