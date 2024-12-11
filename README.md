# Symfony Docker

A simple archive that provides a development and production container for Symfony applications based on Docker. Uses FrankenPHP, MariaDB, phpMyAdmin and Mailpit. Node.js is also supported and a basic Visual Studio Code customization is included.

## ✨ Quick start

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
5. If you plan to use **Docker in production**, add FrankenPHP runtime:
    ```bash
    composer require --no-update runtime/frankenphp-symfony
    ```
6. Install **Symfony**:
    ```bash
    composer install
    ```

> [!IMPORTANT]
> PHPStan **will fail** if the `tests` folder is missing and you haven't installed either the `webapp` or `symfony/test-pack` packages. To resolve this, you can either install these packages or modify the `phpstan.dist.neon` configuration file.

## ⚙️ Configuration

> [!NOTE]
> Composer version cannot be changed at the moment and is locked to the latest version.

Various versions can be set by changing the `compose.yaml` file:

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

## 🧑‍💻 Development tips

> [!NOTE]
> The `app` database is automatically created and can be accessed by the `app` user using the password `!ChangeMe!`. The same password is also assigned to the `root` user.

Available endpoints are:

| URL                                            | Service     |
|------------------------------------------------|-------------|
| [https://localhost](https://localhost)         | App         |
| localhost:3306                                 | MariaDB     |
| [http://localhost:8080](http://localhost:8080) | phpMyAdmin  |
| [http://localhost:8025](http://localhost:8025) | Mailpit     |

Visual Studio Code extensions installed and configured by default:

- [PHP](https://marketplace.visualstudio.com/items?itemName=DEVSENSE.phptools-vscode)
- [Git History](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory)
- [EditorConfig](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)
- [PHP CS Fixer](https://marketplace.visualstudio.com/items?itemName=junstyle.php-cs-fixer)
- [DotENV](https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv)
- [PHPUnit Test Explorer](https://marketplace.visualstudio.com/items?itemName=recca0120.vscode-phpunit)
- [JSON Schema Store Catalog](https://marketplace.visualstudio.com/items?itemName=remcohaszing.schemastore)
- [PHPStan](https://marketplace.visualstudio.com/items?itemName=swordev.phpstan)

## 🚀 Production tips

Create the `.env.prod.local` file to set up the environment for all containers:

> [!IMPORTANT]
> In production, all environment files are ignored except for `.env.prod.local`. The `.env` file will only be used to generate the `.env.local.php` file.

```env
# The domain name, HTTPS certificate is installed automatically
SERVER_NAME="example.com"

# The timezone used by all containers
TZ="Europe/Rome"

# Symfony container variables
DATABASE_URL="mysql://$MARIADB_USER:$MARIADB_PASSWORD@db:3306/$MARIADB_DATABASE?charset=utf8"

# MariaDB container variables
MARIADB_DATABASE="app"
MARIADB_USER="app"
MARIADB_PASSWORD="MySecretPassword"
MARIADB_ROOT_PASSWORD="MySecretRootPassword"
```

To run the project in production, execute `docker compose up -d`. FrankenPHP worker mode is enabled by default.

## ❤️ Contributing

All kinds of contributions are welcome and appreciated. See the [contributing](.github/CONTRIBUTING.md) guidelines, the community looks forward to your contributions!

## 📘 License

Released under the terms of the [ISC License](LICENSE).
