class Front::BidPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.bids.all if scope.under_review? || scope.reviewed?

      raise Pundit::NotAuthorizedError
    end
  end

  def show?
    record.under_review? || record.reviewed?
  end
end
