# User Documentation

## Services

The stack provides the following services:

| Service | Role | Access |
|---------|------|--------|
| **NGINX** | Reverse proxy with TLS | `https://rraumain.42.fr` (port 443) |
| **WordPress** | Website and CMS | Through NGINX |
| **MariaDB** | Database server | Internal only (port 3306) |

## Starting and stopping

Start all services:
```bash
make
```

Stop all services:
```bash
make down
```

Full restart from scratch:
```bash
make re
```

## Accessing the website

- **Website**: `https://rraumain.42.fr`
- **Admin panel**: `https://rraumain.42.fr/wp-admin`

The browser will warn about the self-signed TLS certificate. Accept the exception to proceed.

## Credentials

Credentials are stored in two locations, both excluded from Git:

- `secrets/credentials.txt` - WordPress admin and user accounts
- `secrets/db_password.txt` - Database user password
- `secrets/db_root_password.txt` - Database root password

The WordPress admin username is defined in `secrets/credentials.txt` as `ADMIN_USER`. The admin username must not contain "admin" or "Admin" (42 subject rule).

## Checking service status

Verify all containers are running:
```bash
docker compose -f srcs/docker-compose.yml ps
```

View logs for a specific service:
```bash
docker compose -f srcs/docker-compose.yml logs mariadb
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs nginx
```

Follow logs in real time:
```bash
docker compose -f srcs/docker-compose.yml logs -f
```

Check if the website responds:
```bash
curl -k https://rraumain.42.fr
```
