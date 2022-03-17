class Tag < ApplicationRecord
  before_save { name.downcase! }

  validates :name, presence: true
end
