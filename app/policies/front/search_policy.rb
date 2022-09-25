module Front
  class SearchPolicy < ApplicationPolicy
    def index?
      user&.has_approved_membership?
    end

    def results?
      user&.has_approved_membership?
    end

    def new?
      user&.has_approved_membership?
    end
  end
end
