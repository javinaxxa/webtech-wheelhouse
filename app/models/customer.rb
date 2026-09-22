class Customer < ApplicationRecord
  has_many :bikes, dependent: :restrict_with_error
  has_many :repairs, through: :bikes, dependent: :restrict_with_error

  validates :name, :phone, presence: true

  scope :by_name, -> { order(:name) }
end
