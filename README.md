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

- Ruby 3.4.5
- Rails 8.1
- Node 26.1.0 and Yarn 1.22 
- PostgreSQL 17.5, running locally. The application connects using your local system role.
- libvips, which Active Storage uses to generate the thumbnails of the intake photos.
  On macOS: `brew install vips`. On Debian or Ubuntu: `sudo apt install libvips`.
  Check it with `vips --version`; without it the repairs index raises when it draws a thumbnail.

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

Then open `http://localhost:3000`. Every page reads from the seeded database: the navbar links to the list of repairs, bikes, customers, services and staff, and each row links to its own page. The repairs index shows a thumbnail of the intake photos and the beginning of the diagnosis on each row.

## The JSON API

Wheelhouse answers two programs that are not a browser: the shop's website, which shows the price
list, and the accounting program, which reads the repairs. The routes, the documents and the
decisions behind them are in [`docs/api.md`](docs/api.md).

### The token

Reading the repairs and creating a service need a bearer token. It lives in the encrypted
credentials of the application, under `api.token`, so it is never in the code or in the repository.

On a fresh clone you set your own:

```bash
bin/rails credentials:edit
```

and add, at the end of the file that opens:

```yaml
api:
  token: <a long random string of your own>
```

`bin/rails runner 'puts SecureRandom.hex(32)'` prints one. Without `config/master.key`, which is not
committed, the credentials cannot be read: generate the file again with your own token.

### Asking the API from the terminal

The price list is public:

```bash
curl http://localhost:3000/api/v1/services
```

The repairs need the token:

```bash
curl -H "Authorization: Bearer <your token>" http://localhost:3000/api/v1/repairs
```

### The page that reads it

The price list is also on my personal page:
[javinaxxa.github.io/webtech-lab-01](https://javinaxxa.github.io/webtech-lab-01/), under
"Wheelhouse price list". It reads this API with `fetch`, so the application has to be running on
**port 3000** for the section to show anything; otherwise it says the shop's server is offline.

The API allows that page's origin and a local server on port 8000, and no other. To serve the page
while developing:

```bash
cd ../webtech-lab-01
python3 -m http.server 8000
```
