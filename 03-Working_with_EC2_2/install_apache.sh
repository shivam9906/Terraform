#!/bin/bash
# Update packages
apt update -y

# Install Java 17
apt install -y openjdk-17-jdk

# Install Apache
apt install -y apache2

# Simple web page
echo "Java 17 and Apache installed via Terraform" > /var/www/html/index.html

# Start and enable Apache
systemctl start apache2
systemctl enable apache2
