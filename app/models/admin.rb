class Admin < ApplicationRecord
  # Disable admin from changing their email
  attr_readonly :email

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable, :confirmable,
    :recoverable, :rememberable, :validatable, :lockable, :timeoutable

  enum affiliation: {
    board_member: 0,
    staff_member: 1
  }

  enum status: {
    active: 0,
    inactive: 1
  }

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
