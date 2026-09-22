class Repair < ApplicationRecord
  belongs_to :bike
  belongs_to :received_by, class_name: "StaffMember"
  belongs_to :assigned_mechanic, class_name: "StaffMember", optional: true
  has_many :repair_line_items
  has_many :service_types, through: :repair_line_items
end