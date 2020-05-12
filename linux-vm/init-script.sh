#!/bin/bash

echo "Running apt update"
apt-get update -y
echo "Installing nginx"
apt-get install nginx -y

# echo "Hi Virtual DevOps & Cloud Conference" > index.html
# sudo mv index.html /var/www/html/