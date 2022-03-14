class Category < ApplicationRecord
  has_many :posts, dependent: :nullify, inverse_of: :category

  before_save { name.downcase! }

  validates :name, presence: true, length: {maximum: 50}
end
