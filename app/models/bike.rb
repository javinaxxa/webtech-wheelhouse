class Bike < ApplicationRecord
  belongs_to :customer
  has_many :repairs, dependent: :restrict_with_error

  before_validation :normalize_serial_number

  validates :make, :model, :color, :serial_number, presence: true
  validates :serial_number, uniqueness: { message: "is already on file for another bike" }

  scope :by_make_and_model, -> { order(:make, :model, :serial_number) }

  private

  def normalize_serial_number
    self.serial_number = serial_number&.strip&.upcase
  end
end
