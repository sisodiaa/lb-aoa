class Property < ApplicationRecord
  belongs_to :apartment, inverse_of: :properties
  belongs_to :owner, inverse_of: :properties

  validates :purchased_on, presence: true
  validate :purchased_on_date_cannot_be_in_the_future
  validates :registered, inclusion: [true, false]
  validates :primary_owner, inclusion: [true, false]

  private

  def purchased_on_date_cannot_be_in_the_future
    errors.add(:purchased_on, "can not be in the future") if purchased_on.try(:future?)
  end
end
