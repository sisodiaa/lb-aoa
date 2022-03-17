class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :posts, through: :taggings

  before_save { name.downcase! }

  validates :name, presence: true, uniqueness: true
end
