#!/bin/bash
#Début du scripte /  Made by © 2022-2023 Ethan Besson

# Update and upgrade the system
sudo apt-get update -y && sudo apt-get upgrade -y

# Install Nginx
sudo apt-get install nginx -y

# Enable and start Nginx
sudo systemctl enable nginx && sudo systemctl start nginx

# Check Nginx status
sudo systemctl --no-pager status nginx

# Install necessary packages for PHP
apt -y install lsb-release apt-transport-https ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# Update the system again
sudo apt-get update -y

# Install PHP8.2 and necessary extensions
sudo apt-get install php8.3 php8.3-common php8.3-curl php8.3-fpm php8.3-imap php8.3-redis php8.3-cli php8.3-snmp php8.3-xml php8.3-zip php8.3-mbstring php8.3-mysql php8.3-gd php-gd php-xml php-mysql php-mbstring -y

# Check PHP version
php -v

# Install MariaDB server
sudo apt-get install mariadb-server -y

# Start and enable MariaDB
sudo systemctl start mariadb && sudo systemctl enable mariadb

# Check MariaDB status
sudo systemctl --no-pager status mariadb

# Generate a random password
password=$(openssl rand -base64 32)

# Execute SQL commands
sudo mysql -u root -e "
CREATE USER 'drupal'@'localhost' IDENTIFIED BY '$password';
CREATE DATABASE drupal;
GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost';
FLUSH PRIVILEGES;
"

# Navigate to the /var/www/html directory
cd /var/www/html

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Allow Composer to run as super user and download and install Drupal with Composer
COMPOSER_ALLOW_SUPERUSER=1 composer create-project drupal/recommended-project drupal/ --no-interaction

# Unset the COMPOSER_ALLOW_SUPERUSER environment variable
unset COMPOSER_ALLOW_SUPERUSER

# Change the owner of the drupal directory
chown -R www-data:www-data drupal/

# Set the correct permissions for directories and files
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;

# Navigate to the Nginx sites-available directory
cd /etc/nginx/sites-available/

# Create a new configuration file
touch drupal

# Get the public IP address
public_ip=$(curl -s ifconfig.me)

# Add content to the drupal file
echo "server {
    listen 80;
    server_name $public_ip;
    root /var/www/html/drupal/web;

    location / {
        try_files \$uri /index.php\$is_args\$args;
    }

    location ~ ^/index\.php(/|$) {
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT \$realpath_root;
        internal;
    }

    location ~ \.php$ {
        return 404;
    }

    error_log /var/log/nginx/drupal_error.log;
    access_log /var/log/nginx/drupal_access.log;
}" > drupal

# Enable the drupal site
sudo ln -s /etc/nginx/sites-available/drupal /etc/nginx/sites-enabled/

# Test the Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx

# Uncomment extensions in php.ini
sudo sed -i 's/;extension=gd/extension=gd/' /etc/php/8.3/cli/php.ini
sudo sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/8.3/cli/php.ini

# Uncomment extensions in php.ini
sudo sed -i 's/;extension=gd/extension=gd/' /etc/php/8.3/fpm/php.ini
sudo sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/8.3/fpm/php.ini

# Restart PHP-FPM
sudo systemctl restart php8.3-fpm
clear

# Display a completion message
echo "Drupal installation completed successfully!"
echo "http://$public_ip"

# Print the information to a text file in the home directory
echo "Database name: drupal" > /home/debian/db_credentials.txt
echo "Database user: drupal" >> /home/debian/db_credentials.txt
echo "Database password: $password" >> /home/debian/db_credentials.txt

# Display the username and password at the end
echo "Database name: drupal"
echo "Database user: drupal"
echo "Database password: $password"
