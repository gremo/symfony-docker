# Symfony Docker

## 🚀 Quick start

1. Download the **latest release** and unzip the archive
2. Open Visual Studio Code and reopen the project in the **Dev Container**
3. Download the **Symfony Skeleton**:
    ```bash
    curl -O https://raw.githubusercontent.com/symfony/skeleton/refs/heads/7.1/composer.json
    ```
4. Install Symfony
    ```bash
    composer install
    ```

## ⚙️ Configuration

```yaml
# compose.yaml
services:
    php:
        build:
            args:
                # Set the FrankenPHP version (default latest).
                FRANKENPHP_TAG: php8
                # Install Node.js with npm and Yarn (default empty).
                NODE_VERSION: current

        db:
            # Set the MariaDB version (default latest)
            image: mariadb:latest
```

## 📡 Endpoints

| URL                                            | Servizio    |
|------------------------------------------------|-------------|
| [https://localhost](https://localhost)         | App         |
| [http://localhost:8080](http://localhost:8080) | phpMyAdmin  |
| [http://localhost:8025](http://localhost:8025) | Mailpit     |

## ❤️ Contributing

All types of contributions are encouraged and valued. See the [contributing](.github/CONTRIBUTING.md) guidelines, the community looks forward to your contributions!

## 📘 License

Released under the terms of the [ISC License](LICENSE).
