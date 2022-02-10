class TMS::TenderDocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    record.draft?
  end

  def destroy?
    record.draft?
  end
end
