db-up:
	docker-compose -f docker-compose.yml up --remove-orphans postgres pgadmin

import-csv:
	go run ./cmd/import-csv/main.go

import-xlsx:
	go run ./cmd/import-xlsx/main.go

