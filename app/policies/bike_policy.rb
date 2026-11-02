# A bike is written at the counter, when its owner brings it in.
class BikePolicy < ApplicationPolicy
  def index?
    owner? || counter?
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    owner?
  end

  def permitted_attributes
    return [] unless create?

    [:customer_id, :make, :model, :color, :serial_number]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      user&.owner? || user&.counter? ? scope.all : scope.none
    end
  end
end
