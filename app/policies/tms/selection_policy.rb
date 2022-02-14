class TMS::SelectionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    record.under_review?
  end

  def create?
    record.under_review?
  end
end
