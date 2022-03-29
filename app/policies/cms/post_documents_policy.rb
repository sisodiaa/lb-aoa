class CMS::PostDocumentsPolicy < ApplicationPolicy
  def create?
    record.draft?
  end

  def destroy?
    record.draft?
  end
end
