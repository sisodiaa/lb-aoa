require "application_system_test_case"

module CMS
  class ClassificationsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @public_post = posts(:nursery)
      @private_post = posts(:lotus)
    end

    teardown do
      @confirmed_board_admin = @private_post = @public_post = nil
      Warden.test_reset!
    end

    test "classify a post" do
      toggle_visibility_of_a_published_post(@public_post) do
        assert_selector "input[name='post[visibility_state]'][value='visitors']", visible: false
        find("label[for='post_visibility_state']").click
        assert_selector "input[name='post[visibility_state]'][value='members']", visible: false
      end
    end

    test "declassify a post" do
      toggle_visibility_of_a_published_post(@private_post) do
        assert_selector "input[name='post[visibility_state]'][value='members']", visible: false
        find("label[for='post_visibility_state']").click
        assert_selector "input[name='post[visibility_state]'][value='visitors']", visible: false
      end
    end

    private

    def toggle_visibility_of_a_published_post(post)
      login_as @confirmed_board_admin, scope: :admin
      visit cms_post_url(post)
      assert_selector "#post-toggler"

      within "##{dom_id(post, :visibility)}" do
        yield if block_given?
      end

      assert_selector :css, "[role='toast']", text: "Visibility state was successfully modified."
      logout :admin
    end
  end
end
