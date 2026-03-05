# Developer Documentation

## Prerequisites

- Docker Engine 20.10+
- Docker Compose v2
- GNU Make
- `sudo` access (for data directory creation/deletion)

## Setting up from scratch

1. Clone the repository.

2. Create the `secrets/` directory at the project root with three files:

   `secrets/db_password.txt`:
   ```
   your_db_password
   ```

   `secrets/db_root_password.txt`:
   ```
   your_db_root_password
   ```

   `secrets/credentials.txt`:
   ```
   ADMIN_USER=your_wp_admin
   ADMIN_PASSWORD=your_wp_admin_pass
   ADMIN_EMAIL=admin@example.com
   USER_LOGIN=your_wp_user
   USER_PASSWORD=your_wp_user_pass
   USER_EMAIL=user@example.com
   ```

3. Create `srcs/.env`:
   ```
   DOMAIN_NAME=rraumain.42.fr
   SITE_TITLE=Inception
   MYSQL_DATABASE=wordpress
   MYSQL_USER=wpuser
   MYSQL_HOST=mariadb
   ```

4. Add the domain to `/etc/hosts`:
   ```
   127.0.0.1 rraumain.42.fr
   ```

5. Build and launch:
   ```bash
   make
   ```

## Building and launching

The Makefile targets call `docker compose` with the compose file at `srcs/docker-compose.yml`.

| Target | Action |
|--------|--------|
| `make` / `make all` | Create data directories, build images, start containers |
| `make down` | Stop and remove containers |
| `make clean` | Stop containers, prune all unused Docker objects |
| `make fclean` | Full cleanup: remove host data directories and all volumes |
| `make re` | Full rebuild (`fclean` then `all`) |

## Managing containers and volumes

Enter a running container:
```bash
docker exec -it mariadb bash
docker exec -it wordpress bash
docker exec -it nginx bash
```

List volumes:
```bash
docker volume ls
```

Inspect a volume:
```bash
docker volume inspect srcs_mariadb
docker volume inspect srcs_wordpress
```

## Data persistence

Data is stored on the host machine at `/home/rraumain/data/`:

| Path | Content | Docker Volume |
|------|---------|---------------|
| `/home/rraumain/data/mariadb` | MariaDB database files | `srcs_mariadb` |
| `/home/rraumain/data/wordpress` | WordPress PHP files | `srcs_wordpress` |

These are Docker named volumes configured with the `local` driver and `bind` option. Data persists across container restarts and rebuilds. Only `make fclean` deletes this data.

## Architecture

```
Internet
   |
   | :443 (HTTPS/TLS)
   v
[NGINX] --- :9000 (FastCGI) ---> [WordPress + PHP-FPM]
                                        |
                                        | :3306 (MySQL)
                                        v
                                    [MariaDB]
```

All three containers share the `inception` bridge network. Secrets are mounted read-only at `/run/secrets/` inside each container that needs them.
