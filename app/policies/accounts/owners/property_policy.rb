class Accounts::Owners::PropertyPolicy < ApplicationPolicy
  def edit?
    record.membership.approved? || record.membership.rejected?
  end

  def update?
    record.membership.approved? || record.membership.rejected?
  end
end
