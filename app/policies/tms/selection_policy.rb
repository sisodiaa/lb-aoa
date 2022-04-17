class TMS::SelectionPolicy < ApplicationPolicy
  def new?
    record.under_review?
  end

  def create?
    record.under_review?
  end
end
