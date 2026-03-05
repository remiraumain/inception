LOGIN = rraumain
DATA_DIR = /home/$(LOGIN)/data

all: setup
	docker compose -f srcs/docker-compose.yml up --build -d

setup:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker system prune -af

fclean: clean
	@sudo rm -rf $(DATA_DIR)
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

re: fclean all

.PHONY: all setup down clean fclean re
