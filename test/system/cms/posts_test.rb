require "application_system_test_case"

module CMS
  class PostsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_post = posts(:plantation)

      @draft_post.documents.each do |document|
        attach_file_to_record document.file, "square.png", "image/png"
      end

      login_as @confirmed_board_admin, scope: :admin
    end

    teardown do
      logout :admin
      @confirmed_board_admin = @draft_post = nil
      Warden.test_reset!
    end

    test "creating a Post" do
      create_new_post
      assert_selector "h1", text: "Do not pluck flowers"
      assert_selector "[role='toast']", text: "Post was successfully created."
    end

    test "showing error when title is not present" do
      create_new_post_without_title
      assert_selector "#error_explanation li", text: "Title can't be blank"
    end

    test "updating a post" do
      edit_first_post
      assert_selector "[role='toast']", text: "Post was successfully updated"
      assert_selector "h1", text: "Edited title for system test"
    end

    test "destroying a Post" do
      delete_first_post
      assert_selector "[data-dashboard--list-target='item']", count: 5
      assert_selector :css, "[role='toast']", text: "Post was successfully destroyed."
    end

    test "show actionable buttons for drafts" do
      visit cms_post_url(@draft_post)
      within("#post-actions") do
        assert_selector "button", text: "Publish Post"
        assert_selector "a", text: "Add attachment"
        assert_selector "a", text: "Edit"
      end
    end

    test "do not show Edit and Publish Post button for published posts" do
      visit cms_post_url(posts(:lotus))
      assert_no_selector "#post-actions"
      assert_no_selector "a", text: "Edit"
      assert_no_selector "button", text: "Publish Post"
    end

    private

    def create_new_post
      visit management_dashboard_url
      click_on "Create New Post"

      select "horticulture", from: "post[category_id]"
      fill_in "Title", with: "Do not pluck flowers"
      content = "Be a responsible resident, and care for flowers & trees."
      find(:xpath, "//trix-editor[@id='post__content']").set(content)
      click_on "Create Post"
    end

    def create_new_post_without_title
      visit management_dashboard_url
      click_on "Create New Post"
      click_on "Create Post"
    end

    def edit_first_post
      visit cms_posts_url(status: "draft", page: 1)
      click_on "Show", match: :first
      click_on "Edit"

      fill_in "Title", with: "Edited title for system test"
      click_on "Update Post"
    end

    def delete_first_post
      visit cms_posts_url(status: "draft", page: 1)
      page.accept_confirm do
        click_on "Delete", match: :first
      end
    end
  end
end
