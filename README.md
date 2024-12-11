# Symfony Docker

A simple archive that provides a development and production container for Symfony applications based on Docker. Uses FrankenPHP, MariaDB, phpMyAdmin and Mailpit.

## 🚀 Quick start

1. Download the [**latest release**](https://github.com/gremo/symfony-docker/releases/download/latest/symfony-docker.zip) and unzip the archive.
2. Open Visual Studio Code and reopen the project in the **Dev Container**.
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

> [!NOTE]
> In development, the database `app` is created and accessible by the user `app` with the password `!ChangeMe!` (same password for `root`). In production, you are forced to set the `DATABASE_URL` AND `MARIADB_*` variables in the `.env.prod.local` file.

| URL                                            | Servizio    |
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
