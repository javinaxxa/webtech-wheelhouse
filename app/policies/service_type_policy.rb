# The price list is on the shop's website, so reading it is open to anybody.
# Only the owner sets prices.
class ServiceTypePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    owner?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def permitted_attributes
    return [] unless owner?

    [:name, :current_price]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
