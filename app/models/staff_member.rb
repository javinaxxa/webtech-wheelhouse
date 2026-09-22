class StaffMember < ApplicationRecord
  has_many :received_repairs, class_name: "Repair", foreign_key: :received_by_id,
                              dependent: :restrict_with_error
  has_many :assigned_repairs, class_name: "Repair", foreign_key: :assigned_mechanic_id,
                              dependent: :nullify

  validates :name, :role, presence: true

  scope :by_role_and_name, -> { order(:role, :name) }
end
