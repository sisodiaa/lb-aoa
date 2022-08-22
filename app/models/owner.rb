class Owner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable, :confirmable,
    :recoverable, :rememberable, :validatable, :lockable, :timeoutable

  enum account_status: {
    unlinked: 0,
    linked: 1,
    archived: 2
  }
end
