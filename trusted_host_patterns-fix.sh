# Get the public IP address
public_ip=$(curl -s ifconfig.me)

# Add the trusted_host_patterns setting to the settings.php file
sudo sed -i "s/^# *\\\$settings\['trusted_host_patterns'\] = \[\];/\$settings['trusted_host_patterns'] = [\n    '^$public_ip$',\n    '^127\\.0\\.0\\.1$',\n    '^localhost$',\n];/" /var/www/html/drupal/sites/default/settings.php
