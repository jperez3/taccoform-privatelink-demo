#!/bin/bash

# Disabling services
sudo service sshd stop
systemctl disable sshd

# Update instance
sudo yum -y update

# Configure nginx
sudo amazon-linux-extras install nginx1 -y
echo "<html><body><h1>IT'S TOSTADA TIME</h1></body></html>" | sudo tee /usr/share/nginx/html/index.html
sudo systemctl start nginx
