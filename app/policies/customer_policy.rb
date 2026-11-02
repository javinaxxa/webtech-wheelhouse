# Customers belong to the front of the shop. A mechanic works on bikes, not on
# the people who own them, so they have no access at all.
class CustomerPolicy < ApplicationPolicy
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

  # Only the owner removes a customer from the books.
  def destroy?
    owner?
  end

  def permitted_attributes
    return [] unless create?

    [:name, :phone]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      user&.owner? || user&.counter? ? scope.all : scope.none
    end
  end
end
