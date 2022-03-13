class Category < ApplicationRecord
  before_save { name.downcase! }

  validates :name, presence: true, length: {maximum: 50}
end
