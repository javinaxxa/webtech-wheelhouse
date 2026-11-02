# The owner runs the workshop, the counter books bikes in and follows them, and a
# mechanic only sees the repairs assigned to them.
class RepairPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    owner? || counter? || own_repair?
  end

  # Bikes are taken in at the counter.
  def create?
    owner? || counter?
  end

  def update?
    return true if owner?
    return !record.handed_back? if counter?

    own_repair? && !record.handed_back?
  end

  def destroy?
    owner?
  end

  # A mechanic changes the state and the diagnosis of their repairs, and adds
  # photos. The bike, the mechanic, the promised day and the charged prices are
  # the counter's business.
  def permitted_attributes
    return [] unless update? || create?

    if mechanic?
      [:status, :diagnosis, { intake_photos: [] }]
    else
      [:bike_id, :received_by_id, :assigned_mechanic_id, :status,
       :promised_on, :dropped_off_at, :completed_at, :picked_up_at,
       :customer_approved, :diagnosis,
       { intake_photos: [] },
       { repair_line_items_attributes: [[:id, :service_type_id, :price_charged,
                                         :discount_note, :_destroy]] }]
    end
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none if user.blank?
      return scope.all if user.owner? || user.counter?
      return scope.none if user.staff_member.blank?

      scope.where(assigned_mechanic_id: user.staff_member_id)
    end
  end

  private

  # An account with the role mechanic that belongs to no member of the staff has
  # no repairs of its own.
  def own_repair?
    mechanic? &&
      staff_member.present? &&
      record.assigned_mechanic_id == staff_member.id
  end
end
