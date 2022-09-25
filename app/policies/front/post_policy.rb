module Front
  class PostPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        return Post.for_visitors.ordered_by_published_date unless user&.has_approved_membership?
        Post.for_approved_members.ordered_by_published_date
      end
    end

    def show?
      user.has_approved_membership?
    end
  end
end
