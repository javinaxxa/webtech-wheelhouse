# Everybody in the workshop sees who works there. Only the owner hires,
# changes a role or removes somebody.
class StaffMemberPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
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

    [:name, :role]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      user.present? ? scope.all : scope.none
    end
  end
end
