class TMS::BidPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    record.current?
  end

  def create?
    record.current?
  end
end
