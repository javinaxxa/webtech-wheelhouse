# Wheelhouse API v1

Two programs read Wheelhouse without a browser: the shop's website, which shows the price list, and
the accounting program, which reads the repairs that were handed back.

Every route lives under `/api/v1`. Every response is JSON, including the errors.

## Routes

| Verb | Path | Token | Statuses |
|---|---|---|---|
| `GET` | `/api/v1/services` | no | `200` |
| `GET` | `/api/v1/services/:id` | no | `200`, `404` |
| `POST` | `/api/v1/services` | yes | `201`, `400`, `401`, `422` |
| `GET` | `/api/v1/repairs` | yes | `200`, `400`, `401` |
| `GET` | `/api/v1/repairs/:id` | yes | `200`, `401`, `404` |

`GET /api/v1/repairs` accepts `?state=`, with one of the states of the lifecycle:
`dropped_off`, `awaiting_approval`, `in_progress`, `ready_for_pickup`, `picked_up`, `declined`.
Any other value answers `400`.

## The token

The private routes read an `Authorization` header with the `Bearer` scheme:

```
Authorization: Bearer <the token>
```

The token lives in the encrypted credentials of the application, under `api.token`. A token in the
query string or in the body is not read.

## A service

```json
{
  "id": 1,
  "name": "Basic tune-up",
  "price": "18000",
  "charged_on_repairs": 2
}
```

`GET /api/v1/services` answers a list of these, ordered by name. `GET /api/v1/services/:id` and
`POST /api/v1/services` answer one, with the same keys.

`charged_on_repairs` is not a column: it counts the repairs the service has been charged on, so a
client does not have to ask twice.

## A repair

```json
{
  "id": 1,
  "state": "in_progress",
  "dropped_off_at": "2026-10-03T01:51:33Z",
  "promised_on": "2026-10-08",
  "handed_back_at": null,
  "customer_approved": true,
  "overdue": true,
  "total": "26000",
  "bike": {
    "make": "Trek",
    "model": "Marlin 7",
    "serial_number": "TM-1001"
  },
  "customer": {
    "name": "Javiera Carrasco"
  },
  "lines": [
    { "service": "Basic tune-up", "price_charged": "18000" },
    { "service": "Wheel true", "price_charged": "8000" }
  ]
}
```

`GET /api/v1/repairs` answers a list of these, ordered by the promised day.

`total`, `overdue` and `customer_approved` are not columns. `total` is the sum of the charged
prices; `overdue` is true when the promised day has passed and the bike has not been handed back.

## An error

Every error has the same shape, whatever its status:

```json
{
  "errors": ["There is no record with that id."]
}
```

A client reads `errors` and shows its strings. For a `422` the list carries one sentence per
validation that failed; for the other statuses it usually carries one.

## Decisions

### A price travels as a string

`"18000"`, not `18000`. The prices are stored as `decimal(10,2)`, and a decimal in JSON is read by
JavaScript as a floating-point number, where exact arithmetic on money is not guaranteed. A string
carries the value as it is stored and lets the client decide how to show it. The shop charges whole
pesos, so no decimals are sent.

`total` and `price_charged` carry a price and follow the same rule.

### What the repair leaves out

The accounting program bills repairs, not people, so the document leaves out:

- **The customer's phone**, which the program never needs and the shop should not hand around.
- **Who received the bike and which mechanic worked on it.** The shop does not bill by person.
- **`completed_at`.** The program cares about the day the bike went back to its owner, which is
  `handed_back_at`, not the day the work ended.
- **The discount note of each line.** It is a note for the counter, not an accounting field.
- **`created_at` and `updated_at`**, which say when a row was written, not what happened in the shop.

No foreign key is in the document either: the bike and the customer travel inside it, by name.
