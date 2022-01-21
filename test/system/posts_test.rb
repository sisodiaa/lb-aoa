require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @draft_post = posts(:plantation)
  end

  teardown do
    @draft_post = nil
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
    assert_text "Post was successfully destroyed"
  end

  private

  def create_new_post
    visit cms_posts_url
    click_on "New Post"

    fill_in "Title", with: "Do not pluck flowers"
    content = 'Be a responsible resident, and care for flowers & trees.'
    find(:xpath, "//trix-editor[@id='post_content']").set(content)
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
      click_on "Destroy", match: :first
    end
  end
end
