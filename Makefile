# Include variables from the .envrc file
include .envrc

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

## setup/db/image: Create docker image with postgres
.PHONY: setup/db/image
setup/db/image:
	@echo 'Create docker image with postgres'
	docker run --name pg-api-template -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=${PG_PASSWORD} -d postgres:12-alpine

## db/create: Create database
.PHONY: db/create
db/create:
	@echo 'Create database'
	docker exec -it pg-api-template createdb --username=root --owner=root api-template

## db/drop: Drop database
db/drop:
.PHONY: db/drop
	@echo 'Drop database'
	docker exec -it pg-api-template dropdb api-template

## db/migration/create name=$1: Creating migration file
.PHONY: db/migration/create
db/migration/create:
	@echo 'Creating migration files for ${name}...'
	migrate create -ext sql -dir ./migrations -seq ${name}

## db/migration/up: Running up migrations
.PHONY: db/migration/up
db/migration/up: confirm
	@echo 'Running up migrations...'
	migrate -path ./migrations -database ${DB_DSN} -verbose up

## db/migration/down: Running down migrations
.PHONY: db/migration/down
db/migration/down:
	@echo 'Running down migrations...'
	migrate -path ./migrations -database ${DB_DSN} -verbose down

## run/api: Run api server
.PHONY: run/api
run/api:
	@echo 'Run api server'
	go run ./cmd/api -cors-trusted-origins="http://localhost:9000"
