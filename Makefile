.PHONY: pg-up pg-create-db pg-down help


include .env
export $(shell sed 's/=.*//' .env)


help:
	@echo "make pg-up        # поднять Postgres контейнер напрямую"
	@echo "make pg-create-db # создать базу данных в уже поднятой БД"
	@echo "make pg-down      # остановить контейнер и удалить том с данными"


pg-up:
	docker run -d \
		--name postgres-ecom-demo \
		-e POSTGRES_USER=${POSTGRES__USER} \
		-e POSTGRES_PASSWORD=${POSTGRES__PASSWORD} \
		-e POSTGRES_DB=${POSTGRES__DB} \
		-p ${POSTGRES__PORT}:5432 \
		-v pgdata-ecom-demo:/var/lib/postgresql/data \
		postgres:17


pg-create-db:
	psql "postgresql://${POSTGRES__USER}:${POSTGRES__PASSWORD}@${POSTGRES__HOST}:${POSTGRES__PORT}/postgres" \
	-c "CREATE DATABASE ${POSTGRES__DB};"


pg-down:
	-docker stop postgres-ecom-demo
	-docker rm postgres-ecom-demo
	-docker volume rm pgdata-ecom-demo
