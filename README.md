# Todo API

A learning project for Elixir, Phoenix, Ecto, and CockroachDB.
Pure REST JSON API — no HTML, no frontend.

## Stack

- Elixir / Phoenix (API mode)
- Ecto (database layer)
- CockroachDB (via Docker)

## Running locally

1. Start the database: `docker-compose up -d`
2. Create and migrate: `mix ecto.setup`
3. Start the server: `mix phx.server`

## Endpoints

| Method | Path      | Description    |
|--------|-----------|----------------|
| GET    | /api/todo     | List all todos |
| GET    | /api/todo/:id | Get one todo   |
| POST   | /api/todo     | Create a todo  |
| PUT    | /api/todo/:id | Update a todo  |
| DELETE | /api/todo/:id | Delete a todo  |

## Todo shape

```json
{
  "id": "UUID", //this is automatically generated
  "customer": "string",
  "type": "string",
  "status": "string",
  "notes": "string", // can't do text as it's isn't usuable by roach
  "deadline": "datetime",
  "inserted_at": "auto",
  "updated_at": "auto"
}
```

---

## Roadmap

### Phase 1 — Project setup
- [x] Scaffold the Phoenix API project
- [x] Write a `docker-compose.yml` for CockroachDB
- [x] Configure Ecto to connect to CockroachDB
- [x] Verify the connection with `mix ecto.create`

> Concepts: Phoenix project structure, Mix, config layers, Ecto Repo

### Phase 2 — Data layer
- [x] Write a migration (defines the `todos` table in the DB)
- [x] Write the `Todo` Ecto schema (Elixir struct that maps to the table)
- [x] Write the `Todos` context (module that owns all DB queries)

> Concepts: Ecto migrations, schemas, changesets, contexts

### Phase 3 — API layer
- [ ] Add routes to `router.ex`
- [ ] Write a `TodoController` with all 5 actions
- [ ] Wire each action to a context function
- [ ] Return proper JSON responses

> Concepts: Phoenix router, controllers, JSON responses, HTTP status codes

### Phase 4 — Smoke test
- [ ] Test all endpoints with `curl` or a REST client
- [ ] Handle the unhappy paths (missing record, bad input)
