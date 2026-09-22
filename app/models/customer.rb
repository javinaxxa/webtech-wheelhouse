class Customer < ApplicationRecord
  has_many :bikes
  has_many :repairs, through: :bikes
end