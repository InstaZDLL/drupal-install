#!/bin/bash
#Début du scripte /  Made by © 2022-2023 Ethan Besson

# Path to the settings.php file
FILE="/var/www/html/drupal/sites/default/settings.php"

# Backup the original file
sudo cp $FILE $FILE.bak

# Get the public IP address
public_ip=$(curl -s ifconfig.me)

# Uncomment the line and change its value
sudo sed -i "s/# \$settings\['trusted_host_patterns'\] = \[\];/\$settings\['trusted_host_patterns'\] = ['^${public_ip}\$', '^127\\.0\\.0\\.1\\$', '^localhost$',];/g" $FILE
