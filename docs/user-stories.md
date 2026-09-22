
## Front desk staff

1. I want to create a new repair record with the customer's name and phone, and the bike's make model, colour and serial number, so that we never hand back the wrong bike to the wrong person again.

2. I want to look up whether a specific bike is ready for pickup by searching the customer's name or phone number, so that I can answer them at the counter without walking to the back to ask a mechanic. (has acceptance criteria)

3. I want to see which repairs are past their promised date, so that I can call the customer before they call us.

4. I want to attach photos of the bike to the repair when it arrives, so that nobody can argue later about who caused a scratch.

5. I want to mark a repair as picked up, so that it stops appearing as a bike currently on the rack.

## Mechanics

6. I want to write a diagnosis for a bike as a readable paragraph or list, so that anyone in the shop can understand what's wrong without asking me directly.

7. I want to select one or more services from the price list for a repair and see the total estimated cost, so that the customer can be told a price before I touch the bike.
(has acceptance criteria)

8. I want to mark a repair as needing the customer's approval before I start work, so that I never spend time on a job the owner hasn't agreed to pay for.

9. I want to see the full repair history of a bike, so that I know what was already done to it, even if it was under a previous owner. (has acceptance criteria)

## Customers

10. I want to be told the price of my repair before it starts, so that I'm not
surprised by the final bill.

11. I want to be given a promised pickup date when I drop off my bike, so that I
know when to come back.

## Visitors (public website)

12. I want to see the shop's list of services and current prices on the website,
so that I can decide whether it's worth bringing my bike in, without phoning to ask.

## Shop owner

13. I want to see how many repairs are currently overdue across the whole shop, so that I know        whether the backlog is getting out of hand and can decide whether to slow down on taking in new bikes or bring in extra help.


## A story that was too big, and how it was split

As a shop worker, I want to manage the repair of a bike.

This fails invest nobody can estimate it, and manage is not one piece of value, it is at least
three different jobs, done by two different roles, at three different moments.

- Story 1 (front desk, at drop-off) : create the repair record
- Story 7 (mechanic, once diagnosed) : record the diagnosis and estimate
- Story 5 (front desk, at the end) : mark the repair as picked up

Each of the three can be built, shipped and used on its own.

## Acceptance criteria

### Story 2 — look up whether a bike is ready

As a front desk staff member, I want to look up whether a specific bike is ready for pickup, so
that I can answer without walking to the back.

Done when:
- Searching by customer name or phone returns every repair for that customer, most recent first
- Each result shows the bike (make, model, serial), the current status, and the promised date
- If the search matches no customer, the screen says so in words, instead of showing an empty table

### Story 7 — select services and see the estimate

As a mechanic, I want to select services from the price list and see the total estimated cost.

Done when:
- Each service added to a repair shows its name and the price
- The total updates immediately as services are added or removed
- A repair can have a price lower than the list price, with a required note explaining why (e.g.
"regular customer")

### Story 9 — see a bike's repair history

As a mechanic, I want to see the full repair history of a bike, so that I know what was already
done to it.

Done when:
- The history is ordered most recent first and shows the date, diagnosis, services performed and
  mechanic for each past repair
- The history shows on the bike regardless of who currently owns it
- If the bike has no prior repairs, the screen says "No previous repairs for this bike" instead of showing an empty table