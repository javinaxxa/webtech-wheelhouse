
## 1. When a customer declines the quote, does that visit still count as a repair?

If a customer says no to the quote and picks up their bike untouched, should that visit still be
recorded, with its diagnosis kept for next time, or should it not count at all since no work was
actually done? I assumed it still counts: the `repairs` table records it with `status = declined`,
and the diagnosis is kept, since a future mechanic benefits from knowing this bike was already
looked at even if nothing was fixed that day. If the answer is no, a declined visit would need to be either excluded from the bike's visible history or not stored as a `repairs` row at all, in which case a separate, lighter-weight `inspections` concept would be needed for "we looked, they said no."

## 2. When a bike is sold, how do we record the change of owner?

The owner mentioned that bikes get sold and the second owner deserves to know the repair history.
Does the system need a full ownership history, recording who owned the bike and for how long, or is
it enough to just update who the current owner is? I assumed the simpler option: `bikes.customer_id` is updated to the new owner, and every past repair stays linked to the bike rather than to whichever customer dropped it off at the time, so the full history is visible to whoever owns it now. If theanswer is that a full history is needed, a single `customer_id` column would not be enough we would need a join table, such as `bike_ownerships` with `bike_id`, `customer_id`, `started_on` and `ended_on`, so the system can answer "who owned this bike when the fork was replaced," not just "whoowns it today."

## 3. Can a repair be handed off between mechanics, or does one own it start to finish?

The owner described three mechanics who each keep their own notes. Is a repair always one
mechanic's responsibility end to end, or can it be handed off partway, with one diagnosing and
another doing the work? I assumed one mechanic per repair, so `repairs.assigned_mechanic_id` is a
single column, matching "each mechanic keeps their own notes." If handoffs are allowed, a single
foreign key could not represent that — it would need to become a `repair_assignments` join table
with `repair_id`, `staff_member_id`, `started_at` and `ended_at`, so more than one mechanic could be linked to the same repair, each for their own stretch of it.
