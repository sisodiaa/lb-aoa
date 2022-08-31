class Apartment < ApplicationRecord
  has_many :properties, dependent: :destroy
  has_many :owners, through: :properties

  validates :tower_number, presence: true, inclusion: {
    in: %w[1 2 3 4 5 6 7 8 9 10 12 12A 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29],
    message: "%{value} is not a valid tower number"
  }

  validates :flat_number, presence: true
end
