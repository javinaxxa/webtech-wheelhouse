class ServiceType < ApplicationRecord
  has_many :repair_line_items, dependent: :restrict_with_error
  has_many :repairs, through: :repair_line_items, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { message: "is already on the price list" }
  validates :current_price, presence: true, numericality: { greater_than: 0, allow_nil: true }

  scope :by_name, -> { order(:name) }
end
