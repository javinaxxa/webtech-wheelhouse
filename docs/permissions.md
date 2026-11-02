# Who may do what

One table per resource. Every rule here is enforced by a policy in `app/policies/`,
and every rule in those policies is in a table here.

An account has one of three roles: **owner**, **counter** or **mechanic**. A new account
created from the sign-up page gets `mechanic`, the role with the fewest permissions; the
reason is in [`decisions.md`](decisions.md).

## Services

The price list is on the shop's website, so reading it needs no account at all.

| Action | Owner | Counter | Mechanic | Visitor |
|---|---|---|---|---|
| Read the list | Yes | Yes | Yes | Yes |
| Read one service | Yes | Yes | Yes | Yes |
| Create | Yes | No | No | No |
| Edit | Yes | No | No | No |
| Delete | Yes | No | No | No |

Only the owner sets prices.

## Staff

| Action | Owner | Counter | Mechanic | Visitor |
|---|---|---|---|---|
| Read the list | Yes | Yes | Yes | No |
| Read one member | Yes | Yes | Yes | No |
| Create | Yes | No | No | No |
| Edit | Yes | No | No | No |
| Delete | Yes | No | No | No |

Everybody in the workshop sees who works there. Only the owner hires, changes a role or
removes somebody. A member of the staff who has an account cannot be deleted at all, by
anybody: the model refuses it.

## Customers

| Action | Owner | Counter | Mechanic | Visitor |
|---|---|---|---|---|
| Read the list | Yes | Yes | No | No |
| Read one customer | Yes | Yes | No | No |
| Create | Yes | Yes | No | No |
| Edit | Yes | Yes | No | No |
| Delete | Yes | No | No | No |

A mechanic works on bikes, not on the people who own them, so they have no access to
customers at all: the index shows the `403` page, and so does any customer's page.

Deleting is the owner's alone. The counter adds and corrects, but removing somebody from
the books is a decision of the shop, not of the front desk.

## Bikes

| Action | Owner | Counter | Mechanic | Visitor |
|---|---|---|---|---|
| Read the list | Yes | Yes | No | No |
| Read one bike | Yes | Yes | No | No |
| Create | Yes | Yes | No | No |
| Edit | Yes | Yes | No | No |
| Delete | Yes | No | No | No |

A bike is written at the counter, when its owner brings it in. Deleting is the owner's,
for the same reason as a customer.

A mechanic who reads one of their repairs sees the make, the model and the serial number
of its bike, and the name of its customer, as plain text: the page shows them, but they
are not links.

## Repairs

| Action | Owner | Counter | Mechanic | Visitor |
|---|---|---|---|---|
| Read the list | Every repair | Every repair | **Only their own** | No |
| Read one repair | Yes | Yes | **Only their own** | No |
| Take one in | Yes | Yes | No | No |
| Edit | Every repair | **Only those not handed back** | **Their own, not handed back** | No |
| Delete | Yes | No | No | No |

**A mechanic's own repairs** are the ones whose mechanic is the member of the staff joined
to their account. An account with the role `mechanic` that belongs to no member of the
staff has no repairs of its own, and reads none: its index is empty.

**A handed-back repair** is one in the state `picked_up`, the final state of the lifecycle
in [`domain-model.md`](domain-model.md). Only the owner edits it.

A mechanic who changes the id in the URL to a repair that is not theirs gets a `404`: the
scope that builds the index is the same one that finds the record, so a repair they do not
see is a repair they cannot open.

### Which fields each role writes

The repair's form is shared, and the policy decides which fields it shows.

| Field | Owner | Counter | Mechanic |
|---|---|---|---|
| State | Yes | Yes | Yes |
| Diagnosis | Yes | Yes | Yes |
| Intake photos | Yes | Yes | Yes |
| Bike | Yes | Yes | No |
| Received by | Yes | Yes | No |
| Mechanic | Yes | Yes | No |
| Dropped off, promised, completed, handed back | Yes | Yes | No |
| Customer's answer | Yes | Yes | No |
| The services charged and their prices | Yes | Yes | No |

A field outside a person's list, added from DevTools, is dropped and the request goes on,
as with any field outside a permitted list.

**The account that took a repair in** is never a field of the form, for anybody. It is read
from the session when the repair is created, and editing a repair does not change it.

## Accounts

No page lists, edits or deletes accounts. Changing a role, or joining an account to a
member of the staff, is done from the console or the seed.
