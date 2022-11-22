module Front
  class CommentPolicy < ApplicationPolicy
    def index?
      user.has_approved_membership?
    end

    def show?
      user.has_approved_membership?
    end

    def new?
      user.has_approved_membership? && record.root_discussion.unlocked?
    end

    def create?
      user.has_approved_membership? && record.root_discussion.unlocked?
    end
  end
end
