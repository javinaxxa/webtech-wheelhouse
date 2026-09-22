class ServiceType < ApplicationRecord
  has_many :repair_line_items
  has_many :repairs, through: :repair_line_items
end