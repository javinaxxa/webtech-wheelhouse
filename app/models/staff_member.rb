class StaffMember < ApplicationRecord
  has_many :received_repairs, class_name: "Repair", foreign_key: :received_by_id
  has_many :assigned_repairs, class_name: "Repair", foreign_key: :assigned_mechanic_id
end