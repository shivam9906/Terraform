terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ open SSH for demo (restrict in real projects)
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Jenkins port
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-08e5424edfe926b43" # Ubuntu 22.04 in ap-south-1
  instance_type = "t2.micro"

  key_name               = "Jenkins_Key"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt upgrade -y
              apt install -y fontconfig openjdk-17-jre curl
              curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | tee \
                /usr/share/keyrings/jenkins-keyring.asc > /dev/null
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                https://pkg.jenkins.io/debian binary/ | tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null
              apt update -y
              apt install -y jenkins
              systemctl enable jenkins
              systemctl start jenkins
              EOF

  tags = {
    Name = "Jenkins-Server"
  }
}


output "jenkins_url" {
  value = "http://${aws_instance.jenkins_server.public_ip}:8080"
}

output "jenkins_initial_admin_password" {
  value = aws_instance.jenkins_server.id
  # Use this ID to fetch the initial admin password from the instance
  # Command: sudo cat /var/lib/jenkins/secrets/initialAdminPassword
}

