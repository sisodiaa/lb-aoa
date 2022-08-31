class Owner < ApplicationRecord
  has_one :profile, dependent: :destroy, inverse_of: :owner

  has_many :properties, dependent: :destroy
  has_many :apartments, through: :properties

  accepts_nested_attributes_for :profile
  validates :profile, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable, :confirmable,
    :recoverable, :rememberable, :validatable, :lockable, :timeoutable

  enum account_status: {
    unlinked: 0,
    linked: 1,
    archived: 2
  }

  def devise_mailer
    OwnerMailer
  end
end
