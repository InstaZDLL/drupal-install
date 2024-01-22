# Drupal Installation Script

This script automates the process of installing Drupal on a Linux server. It performs tasks such as updating the system, installing necessary packages, setting up the database, and configuring Apache and PHP.

## How it Works

The script performs the following steps:

1. **System Update**: The script starts by updating the system's package list and upgrading all installed packages.

2. **Apache Installation**: The script installs Apache and starts the service.

3. **PHP Installation**: The script adds the necessary repositories and installs PHP along with necessary extensions.

4. **MariaDB Installation**: The script installs MariaDB, starts the service, and sets up a new database and user for Drupal.

5. **Drupal Installation**: The script downloads and extracts Drupal in the appropriate directory, sets the correct permissions, and configures Apache to serve the Drupal site.

6. **Final Configuration**: The script makes necessary changes in `php.ini` and `settings.php` files, restarts Apache, and displays the database credentials.

## Usage

To use this script, simply run it on your Linux server. The script will handle the rest:

```bash
wget -O - https://raw.githubusercontent.com/InstaZDLL/drupal-install/main/drupal-install.sh | sudo bash
```

At the end of the script, a file named `db_credentials.txt` will be created in the home directory of the current user. This file contains the database username and a randomly generated password.

## Note

Please handle the `db_credentials.txt` file securely as it contains sensitive information.

## Issues

If

## Contributions

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.
