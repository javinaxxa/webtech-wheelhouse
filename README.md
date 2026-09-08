# Wheelhouse

Wheelhouse is a repair tracking system for a neighbourhood bicycle repair shop. It replaces paper tags tied to handlebars, three mechanics' private notebooks, and phone calls to the back of the shop with one place to see what is happening to every bike currently in for repair.

## Who uses it

- **Front desk staff** — check bikes in, look up whether a bike is ready, hand bikes back
- **Mechanics** — diagnose problems, quote the cost, record what work was done
- **Customers** — get an honest price and a promised date before any work starts
- **Visitors** — browse the shop's price list online without phoning to ask
- **The shop owner** — see how many repairs are overdue across the whole shop

## Design documents

- [`docs/user-stories.md`](docs/user-stories.md) — what the system does, for whom, and why
- [`docs/domain-model.md`](docs/domain-model.md) — the entities, their relationships, and the repair lifecycle
- [`docs/decisions.md`](docs/decisions.md) — open questions for the owner, and the assumptions made in the meantime

## Prerequisites

- Ruby 4.0.4
- Rails 8.0
- Node 26.1.0 and Yarn 1.22 
- PostgreSQL 17.5, running locally. The application connects using your local system role — no separate username or password is configured. If your PostgreSQL installation requires one, adjust `config/database.yml` before running the setup commands below.

## Setup

```bash
git clone <this repository's URL>
cd webtech-wheelhouse
bundle install
yarn install
bin/rails db:prepare
```

`bin/rails db:prepare` creates the database if it doesn't exist, loads the schema, and seeds it one command, for a fresh clone.

## Running the application

```bash
bin/dev
```

`bin/dev` starts the Rails server and Bootstrap's Sass watcher. The compiled CSS is not
version-controlled, so `bin/dev` is how the application is meant to be started: `bin/rails server` on its own will boot it, but with no styles.

Then open `http://localhost:3000`. The services page reads its price list from the seeded database.
