_This project has been created as part of the 42 curriculum by rraumain._

## Description

Inception is a system administration project that sets up a small infrastructure composed of multiple Docker containers, orchestrated with Docker Compose. The stack includes:

- **NGINX** as the sole entry point (port 443, TLS only)
- **WordPress** with PHP-FPM for dynamic content
- **MariaDB** as the relational database

All services run in isolated containers, communicate through a dedicated Docker network, and persist data using named volumes.

### Project description

This project uses **Docker** to containerize each service into its own lightweight, isolated environment. Each container is built from a custom Dockerfile based on Debian bookworm (penultimate stable).

**Virtual Machines vs Docker:**
Virtual machines emulate full hardware and run a complete OS, consuming significant resources. Docker containers share the host kernel, making them faster to start, lighter on resources, and easier to reproduce. Docker is ideal for microservice architectures where each service is isolated but doesn't need a full OS.

**Secrets vs Environment Variables:**
Environment variables are simple to use but can be exposed through process listings or container inspection. Docker secrets store sensitive data (passwords, keys) in encrypted files mounted at `/run/secrets/` inside containers, accessible only to the services that need them. This project uses Docker secrets for all passwords and credentials.

**Docker Network vs Host Network:**
Host networking removes isolation between the container and the host, exposing all container ports directly. A bridge Docker network provides isolation: containers communicate with each other through the internal network while only explicitly published ports are accessible from outside. This project uses a bridge network named `inception`.

**Docker Volumes vs Bind Mounts:**
Bind mounts map a host directory directly into a container, tightly coupling the container to the host filesystem. Named volumes are managed by Docker, providing better portability and lifecycle management. This project uses named volumes with local driver options to store data at `/home/rraumain/data/`.

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- `make` available
- Entry in `/etc/hosts`: `127.0.0.1 rraumain.42.fr`

### Setup

1. Create the secrets files in `secrets/`:
   - `db_password.txt` - MariaDB user password
   - `db_root_password.txt` - MariaDB root password
   - `credentials.txt` - WordPress admin and user credentials (shell variable format)

2. Create `srcs/.env` with:

   ```
   DOMAIN_NAME=rraumain.42.fr
   SITE_TITLE=Inception
   MYSQL_DATABASE=wordpress
   MYSQL_USER=wpuser
   MYSQL_HOST=mariadb
   ```

3. Build and start:

   ```bash
   make
   ```

4. Access the website at `https://rraumain.42.fr`

### Available commands

| Command       | Description                                    |
| ------------- | ---------------------------------------------- |
| `make`        | Build and start all containers                 |
| `make down`   | Stop all containers                            |
| `make clean`  | Stop containers and prune Docker system        |
| `make fclean` | Full cleanup: remove data, volumes, and images |
| `make re`     | Full rebuild from scratch                      |

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose specification](https://docs.docker.com/compose/compose-file/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress CLI handbook](https://make.wordpress.org/cli/handbook/)
- [MariaDB knowledge base](https://mariadb.com/kb/)
- [Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker secrets](https://docs.docker.com/engine/swarm/secrets/)

AI (Claude) was used to assist with debugging the MariaDB initialization script, reviewing Docker Compose configuration, and generating this documentation.
