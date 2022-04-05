class TMS::TenderPolicy < ApplicationPolicy
  def edit?
    record.draft?
  end

  def update?
    record.draft?
  end

  def destroy?
    record.draft?
  end
end
