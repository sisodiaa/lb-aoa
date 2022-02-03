require "application_system_test_case"

class NotificationToastsTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @draft_post = posts(:plantation)

    @draft_post.documents.each do |document|
      attach_file_to_record document.file, "square.png", "image/png"
    end
    login_as @confirmed_board_admin, scope: :admin
    update_post
  end

  teardown do
    logout :admin
    @confirmed_board_admin = @draft_post = nil
    Warden.test_reset!
  end

  test "alert is shown in a toast notification" do
    assert_selector :css, "[role='toast']", text: "Post was successfully updated."
  end

  test "toast notification fades away after 5 seconds" do
    assert_selector :css, "[role='toast']"
    sleep 5
    assert_no_selector :css, "[role='toast']"
  end

  test "toast notification fades away 1 second after clicking close button" do
    assert_selector :css, "[role='toast']"
    within :css, "[role='toast']" do
      find("button[type='button']").click
    end
    sleep 1
    assert_no_selector :css, "[role='toast']"
  end

  private

  def update_post
    visit edit_cms_post_path(@draft_post)
    click_on "Update Post"
  end
end
