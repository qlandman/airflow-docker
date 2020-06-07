SERVICE = "webserver"
TITLE = "airflow containers"
ACCESS = "http://localhost:8080"

.PHONY: run

build:
	docker-compose build

run:
	@echo "Starting $(TITLE)"
	docker-compose up -d
	@echo "$(TITLE) running on $(ACCESS)"

runf:
	@echo "Starting $(TITLE)"
	docker-compose up

stop:
	@echo "Stopping $(TITLE)"
	docker-compose down

restart: stop print-newline run

tty:
	docker-compose run --rm --entrypoint='' $(SERVICE) bash

ttyr:
	docker-compose run --rm --entrypoint='' -u root $(SERVICE) bash

attach:
	docker-compose exec $(SERVICE) bash

attachr:
	docker-compose exec -u root $(SERVICE) bash

logs:
	docker-compose logs --tail 50 --follow $(SERVICE)

conf:
	docker-compose config

initdb:
	docker-compose run --rm $(SERVICE) initdb
	docker-compose run --rm $(SERVICE) airflow create_user -r Admin -u admin -e admin@example.com -f admin -l user -p test

upgradedb:
	docker-compose run --rm $(SERVICE) upgradedb

print-newline:
	@echo ""
	@echo ""