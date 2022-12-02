class Profile < ApplicationRecord
  belongs_to :owner, inverse_of: :profile

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, phone: {allow_blank: true}

  def full_name
    [first_name, middle_name, last_name].select(&:present?).join(" ").titleize
  end

  def complete?
    first_name? && last_name? && phone_number?
  end
end
