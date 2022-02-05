require "application_system_test_case"

module CMS
  class PostsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_post = posts(:plantation)

      login_as @confirmed_board_admin, scope: :admin
    end

    teardown do
      logout :admin
      @confirmed_board_admin = @draft_post = nil
      Warden.test_reset!
    end

    test "creating a Post" do
      create_new_post
      assert_text "Do not pluck flowers"
      assert_text "Post was successfully created"
    end

    test "showing error when title is not present" do
      create_new_post_without_title
      assert_selector "#error_explanation li", text: "Title can't be blank"
    end

    test "updating a post" do
      edit_first_post
      assert_text "Post was successfully updated"
      assert_text "Edited title for system test"
    end

    test "destroying a Post" do
      delete_first_post
      assert_selector "tbody tr", count: 20
      assert_selector :css, "[role='toast']", text: "Post was successfully destroyed."
    end

    test "show Publish Post button for drafts" do
      visit cms_post_url(@draft_post)
      within("#post-publication-section") do
        assert_selector "button", text: "Publish Post"
      end
    end

    test "do not show Edit and Publish Post button for published posts" do
      visit cms_post_url(posts(:lotus))
      within("#post-publication-section") do
        assert_no_selector "a", text: "Edit"
        assert_no_selector "button", text: "Publish Post"
      end
    end

    private

    def create_new_post
      visit cms_posts_url
      click_on "New Post"

      fill_in "Title", with: "Do not pluck flowers"
      content = "Be a responsible resident, and care for flowers & trees."
      find(:xpath, "//trix-editor[@id='post__content']").set(content)
      click_on "Create Post"
    end

    def create_new_post_without_title
      visit new_cms_post_url
      click_on "Create Post"
    end

    def edit_first_post
      visit cms_posts_url
      click_on "Edit", match: :first

      fill_in "Title", with: "Edited title for system test"
      click_on "Update Post"
    end

    def delete_first_post
      visit cms_posts_url
      page.accept_confirm do
        click_on "Delete", match: :first
      end
    end
  end
end
