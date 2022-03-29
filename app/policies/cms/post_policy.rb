class CMS::PostPolicy < ApplicationPolicy
  def update?
    record.draft?
  end

  def destroy?
    record.draft?
  end
end
