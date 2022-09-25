require "application_system_test_case"

module Front
  class PostsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!

      @owner_with_approved_membership = owners(:confirmed_linked_owner)
      @owner_with_under_review_membership = owners(:confirmed_linked_co_owner)

      @published_post_1 = posts(:club_chiller) # visibility state: members
      @published_post_2 = posts(:nursery) # visibility state: visitors
      @published_post_1.documents.each do |document|
        attach_file_to_record document.file, "square.png", "image/png"
      end
    end

    teardown do
      @published_post_1 = @published_post_2 = nil
      @owner_with_approved_membership = @owner_with_under_review_membership = nil
      Warden.test_reset!
    end

    test "#index - visitors" do
      visit posts_url
      assert_selector ".post", count: 1
      assert_no_selector ".visibility-status"
    end

    test "#index - membership under review" do
      login_as @owner_with_under_review_membership, scope: :owner

      visit posts_url
      assert_selector ".post", count: 1
      assert_no_selector ".visibility-status"

      logout :owner
    end

    test "#index - membership approved" do
      authenticated_owner do
        visit posts_url
        assert_selector ".post", count: 6
        assert_selector ".visibility-status", count: 5

        click_link "Next"

        assert_selector ".post", count: 3
        assert_selector ".visibility-status", count: 3
      end
    end

    test "#show post cotent and attachments" do
      authenticated_owner do
        visit post_url(@published_post_1)

        assert_selector ".visibility-status"
        assert_selector "h1", text: @published_post_1.title
        assert_selector ".trix-content"
        assert_selector "turbo-frame#attachments li", count: 1
      end
    end

    test "clicking category lists all published posts belonging to the category" do
      authenticated_owner do
        visit post_url(@published_post_2)

        click_link @published_post_2.category.name

        within "#results" do
          assert_selector ".post", count: 2
        end
      end
    end

    test "clicking date lists all posts published on that date" do
      authenticated_owner do
        visit post_url(@published_post_2)

        assert_no_selector ".visibility-status"
        click_link @published_post_2.published_at.strftime("%d %B %Y")

        within "#results" do
          assert_selector ".post", count: 6
        end
      end
    end

    test "clicking tag lists all posts with that tag" do
      authenticated_owner do
        visit post_url(@published_post_2)

        click_link @published_post_2.tags.first.name

        within "#results" do
          assert_selector ".post", count: 1
        end
      end
    end

    private

    def authenticated_owner
      login_as @owner_with_approved_membership, scope: :owner

      yield if block_given?

      logout :owner
    end
  end
end
