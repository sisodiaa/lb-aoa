class Accounts::Owners::PropertyPolicy < ApplicationPolicy
  def show?
    record.owner == user
  end

  def edit?
    record.owner == user
  end

  def update?
    record.owner == user
  end
end
