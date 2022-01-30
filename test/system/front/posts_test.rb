require "application_system_test_case"

module Front
  class PostsTest < ApplicationSystemTestCase
    setup do
      @published_post = posts(:club_chiller)
      @published_post.documents.each do |document|
        attach_file_to_record(document.file)
      end
    end

    teardown do
      @published_post = nil
    end

    test "#show post cotent and attachments" do
      visit post_url(@published_post)

      assert_selector "h1", text: @published_post.title
      assert_selector ".trix-content"
      assert_selector "turbo-frame#attachments li", count: 1
    end

    test "#index" do
      visit posts_url
      assert_selector ".post", count: 9
    end
  end
end
