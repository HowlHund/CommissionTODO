.PHONY: up down restart server db-create db-migrate setup

up: #make up
	docker-compose up -d

down: #make down
	docker-compose down

restart: down up #make restart

setup: up #make setup
	mix ecto.create
	mix ecto.migrate

server: #make server
	mix phx.server

list: #make list
	curl -s -X GET http://localhost:4000/api/todo | jq

get: #make get id=1
	curl -s -X GET http://localhost:4000/api/todo/$(id) | jq

delete: #make delete id=1
	curl -s -X DELETE http://localhost:4000/api/todo/$(id)

create: #make create customer=test_user type=full_body status=sketching deadline=2026-12-31T00:00:00
	curl -s -X POST http://localhost:4000/api/todo \
		-H "Content-Type: application/json" \
		-d '{"customer": "test_user", "type": "full_body", "status": "sketching", "deadline": "2026-12-31T00:00:00"}' | jq

update: #make update id=1 field=status value=completed
	curl -s -X PUT http://localhost:4000/api/todo/$(id) \
		-H "Content-Type: application/json" \
		-d '{"$(field)": "$(value)"}' | jq
