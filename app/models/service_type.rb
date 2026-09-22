class ServiceType < ApplicationRecord
  has_many :repair_line_items, dependent: :restrict_with_error
  has_many :repairs, through: :repair_line_items, dependent: :restrict_with_error
end
