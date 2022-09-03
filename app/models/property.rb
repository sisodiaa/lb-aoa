class Property < ApplicationRecord
  belongs_to :apartment, inverse_of: :properties
  belongs_to :owner, inverse_of: :properties

  before_validation :create_association_with_apartment, on: :create
  after_validation :remove_apartment_absence_message, if: Proc.new { errors.include?(:apartment) }
  after_validation :destroy_apartment_association, on: :create, if: Proc.new { errors.any? }
  before_create :set_property_token

  attribute :tower_number, :string
  attribute :flat_number, :string

  validates :tower_number, presence: true
  validates :flat_number, presence: true
  validates :property_token, uniqueness: true
  validates :purchased_on, presence: true
  validate :purchased_on_date_cannot_be_in_the_future
  validates :registered, inclusion: {
    in: [true, false],
    message: "status should be either Yes or No"
  }
  validates :primary_owner, inclusion: {
    in: [true, false],
    message: "value should be either Yes or No"
  }

  def to_param
    property_token
  end

  private

  def purchased_on_date_cannot_be_in_the_future
    errors.add(:purchased_on, "date is invalid as it is set in future") if purchased_on.try(:future?)
  end

  def create_association_with_apartment
    apartment = Apartment.where(tower_number: tower_number, flat_number: flat_number).first_or_initialize
    self.apartment_id = apartment.id if apartment&.save
  end

  def remove_apartment_absence_message
    errors.delete(:apartment)
  end

  def destroy_apartment_association
    apartment&.destroy
  end

  def set_property_token
    self.property_token = loop do
      property_token = SecureRandom.hex(4)
      break property_token unless Property.where(property_token: property_token).exists?
    end
  end
end
