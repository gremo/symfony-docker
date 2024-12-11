# Symfony Docker

A simple archive that provides a development and production container for Symfony applications based on Docker. Uses FrankenPHP, MariaDB, phpMyAdmin and Mailpit. Node.js is also supported and a basic Visual Studio Code customization is included.

## 🚀 Quick start

1. Download the [**latest release**](https://github.com/gremo/symfony-docker/releases/download/latest/symfony-docker.zip) and unzip the archive.
2. Open Visual Studio Code and **reopen the project in the Dev Container**.
3. Download the **Symfony Skeleton**:
    ```bash
    curl -O https://raw.githubusercontent.com/symfony/skeleton/refs/heads/7.1/composer.json
    ```
4. Add Dev Container **extensions dependencies**:
    ```bash
    composer require --dev --no-update friendsofphp/php-cs-fixer phpstan/phpstan
    ```
5. Install **Symfony**:
    ```bash
    composer install
    ```

> [!IMPORTANT]
> PHPStan **will fail** if the `tests` folder is missing and you haven't installed either the `webapp` or `symfony/test-pack` packages. To resolve this, you can either install these packages or modify the `phpstan.dist.neon` configuration file.

## ⚙️ Configuration

Various versions can be set changing the `compose.yaml` file:

```yaml
# compose.yaml
services:
    php:
        build:
            args:
                # Set the FrankenPHP version (default latest).
                # Supports any FrankenPHP Docker tag.
                FRANKENPHP_TAG: php8.3
                # Set the Node.js version (default empty, meaning not installed).
                # Supports a major version or keywords "current" and "lts".
                NODE_VERSION: lts

    db:
        # Set the MariaDB version (default latest).
        # Supports any MariaDB Docker tag.
        image: mariadb:11

    phpmyadmin:
        # Set the phpMyAdmin version (default latest).
        # Supports any phpMyAdmin Docker tag.
        image: phpmyadmin:5
```

Other configuration files:

- `config/docker/php*.ini` for PHP
- `config/docker/supervisor.conf` for [Supervisor](http://supervisord.org/)

## 📡 Endpoints

> [!NOTE]
> In development, the database `app` is created and accessible by the user `app` with the password `!ChangeMe!` (same password for `root`). In production, you are forced to set the `DATABASE_URL` AND `MARIADB_*` variables in the `.env.prod.local` file.

| URL                                            | Service     |
|------------------------------------------------|-------------|
| [https://localhost](https://localhost)         | App         |
| [http://localhost:8080](http://localhost:8080) | phpMyAdmin  |
| [http://localhost:8025](http://localhost:8025) | Mailpit     |
| localhost:3306                                 | MariaDB     |

## 🛠️ VSCode extensions

Visual Studio Code installed by default:

- [PHP](https://marketplace.visualstudio.com/items?itemName=DEVSENSE.phptools-vscode)
- [Git History](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory)
- [EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
- [PHP CS Fixer](https://marketplace.visualstudio.com/items?itemName=junstyle.php-cs-fixer)
- [DotENV](https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv)
- [PHPUnit Test Explorer](https://marketplace.visualstudio.com/items?itemName=recca0120.vscode-phpunit)
- [JSON Schema Store Catalog](https://marketplace.visualstudio.com/items?itemName=remcohaszing.schemastore)
- [PHPStan](https://marketplace.visualstudio.com/items?itemName=swordev.phpstan)

## ❤️ Contributing

All types of contributions are encouraged and valued. See the [contributing](.github/CONTRIBUTING.md) guidelines, the community looks forward to your contributions!

## 📘 License

Released under the terms of the [ISC License](LICENSE).
