class Profile < ApplicationRecord
  belongs_to :owner, inverse_of: :profile

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, phone: {allow_blank: true}

  def full_name
    "#{first_name} #{middle_name} #{last_name}".titleize
  end
end
