class Property < ApplicationRecord
  belongs_to :apartment, inverse_of: :properties
  belongs_to :owner, inverse_of: :properties
  has_one :membership, dependent: :destroy

  before_create :set_property_token

  validates :property_token, uniqueness: true

  def to_param
    property_token
  end

  def tower_number
    apartment&.tower_number
  end

  def flat_number
    apartment&.flat_number
  end

  def policy_class
    Accounts::Owners::PropertyPolicy
  end

  private

  def set_property_token
    self.property_token = loop do
      property_token = SecureRandom.hex(4)
      break property_token unless Property.where(property_token: property_token).exists?
    end
  end
end
