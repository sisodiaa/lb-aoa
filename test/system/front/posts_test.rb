require "application_system_test_case"

module Front
  class PostsTest < ApplicationSystemTestCase
    setup do
      @published_post_1 = posts(:club_chiller)
      @published_post_2 = posts(:nursery)
      @published_post_1.documents.each do |document|
        attach_file_to_record document.file, "square.png", "image/png"
      end
    end

    teardown do
      @published_post_1 = @published_post_2 = nil
    end

    test "#show post cotent and attachments" do
      visit post_url(@published_post_1)

      assert_selector "h1", text: @published_post_1.title
      assert_selector ".trix-content"
      assert_selector "turbo-frame#attachments li", count: 1
    end

    test "#index" do
      visit posts_url
      assert_selector ".post-skeleton"
      assert_selector ".post", count: 6

      click_link "Next"
      assert_selector ".post", count: 3
    end

    test "clicking category lists all published posts belonging to the category" do
      visit post_url(@published_post_2)

      click_link @published_post_2.category.name

      within "#results" do
        assert_selector ".post", count: 2
      end
    end

    test "clicking date lists all posts published on that date" do
      visit post_url(@published_post_2)

      click_link @published_post_2.published_at.strftime("%d %B %Y")

      within "#results" do
        assert_selector ".post", count: 6
      end
    end

    test "clicking tag lists all posts with that tag" do
      visit post_url(@published_post_2)

      click_link @published_post_2.tags.first.name

      within "#results" do
        assert_selector ".post", count: 1
      end
    end
  end
end
