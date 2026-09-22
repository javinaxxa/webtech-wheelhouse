class Bike < ApplicationRecord
  belongs_to :customer
  has_many :repairs, dependent: :restrict_with_error

  validates :make, :model, :color, :serial_number, presence: true
  validates :serial_number, uniqueness: { message: "is already on file for another bike" }
end
