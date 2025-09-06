#!/bin/bash
yum install apache2
cd /var/www/html
echo "Created using Terraform" >> index.html
service apache2 start
systemctl enable apache2