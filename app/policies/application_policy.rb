# frozen_string_literal: true

# Every policy starts from here, and here everything is refused. An action whose
# policy method has not been written is denied, never allowed.
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # The attributes this person may write. A policy that allows no writing allows
  # no attributes either.
  def permitted_attributes
    []
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end

  private

  # The role names live in the enum of the model, never as strings in a policy.
  def owner?
    user&.owner?
  end

  def counter?
    user&.counter?
  end

  def mechanic?
    user&.mechanic?
  end

  def staff_member
    user&.staff_member
  end
end
