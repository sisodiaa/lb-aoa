module Management
  class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
      @draft_posts_count = Post.draft.count
      @published_posts_count = Post.published.count
      @categories_count = Category.count

      @draft_tenders_count = Tender.draft.count
      @upcoming_tenders_count = Tender.published.upcoming.count
      @current_tenders_count = Tender.published.current.count
      @under_review_tenders_count = Tender.published.under_review.count
      @reviewed_tenders_count = Tender.published.reviewed.count

      @under_review_memberships_count = Membership.under_review.count
      @approved_memberships_count = Membership.approved.count
      @rejected_memberships_count = Membership.rejected.count
      @archived_memberships_count = Membership.archived.count
    end
  end
end
