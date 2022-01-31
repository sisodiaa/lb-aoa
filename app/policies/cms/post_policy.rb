class CMS::PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    record.draft?
  end

  def destroy?
    record.draft?
  end
end