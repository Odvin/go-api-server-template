postgres:
	docker run --name pg-api-template -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it pg-api-template createdb --username=root --owner=root api-template

dropdb:
	docker exec -it pg-api-template dropdb api-template

migration_file:
	migrate create -ext sql -dir ./migrations -seq $(name)

migrateup:
	migrate -path ./migrations -database "postgresql://root:secret@localhost:5432/api-template?sslmode=disable" -verbose up

migratedown:
	migrate -path ./migrations -database "postgresql://root:secret@localhost:5432/api-template?sslmode=disable" -verbose down


.PHONY: postgres createdb dropdb migration_file migrateup migratedown
