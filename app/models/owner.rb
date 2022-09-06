class Owner < ApplicationRecord
  include AASM

  has_one :profile, dependent: :destroy, inverse_of: :owner

  has_many :properties
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

  aasm column: :account_status, enum: true, no_direct_assignment: true do
    state :unlinked, initial: true
    state :linked
    state :archived

    event :link do
      transitions from: :unlinked, to: :linked
    end
  end

  def devise_mailer
    OwnerMailer
  end
end
