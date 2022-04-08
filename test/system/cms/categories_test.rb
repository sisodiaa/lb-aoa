require "application_system_test_case"

module CMS
  class CategoriesTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @category = categories(:horticulture)

      login_as @confirmed_board_admin, scope: :admin
    end

    teardown do
      logout :admin
      @category = @confirmed_board_admin = nil
      Warden.test_reset!
    end

    test "creating a Category" do
      create_new_category
      assert_selector ".category", count: 10
      assert_selector "[role='toast']", text: "Category was successfully created."
    end

    test "cancel category creation flow" do
      visit_category_form
      click_on "Cancel"
      assert_selector ".card", count: 3
    end

    test "updating a Category" do
      update_category
      assert_selector ".category", count: 9
      assert_selector "[role='toast']", text: "Category was successfully updated."
      within "#category_#{@category.id}" do
        assert_selector "h1", text: "Meeting"
      end
    end

    test "cancel category updation flow" do
      access_category_form
      within "#category_#{@category.id}" do
        assert_selector "form"
        click_on "Cancel"

        assert_no_selector "form"
        assert_selector "h1", text: "Horticulture"
      end
      assert_selector ".category", count: 9
    end

    private

    def create_new_category
      visit_category_form
      fill_in "category_name", with: "Meeting"
      click_on "Create Category"
    end

    def visit_category_form
      visit management_dashboard_url
      click_on "Create New Category"
    end

    def update_category
      access_category_form
      within "#category_#{@category.id}" do
        fill_in "category_name", with: "meeting"
        click_on "Update Category"
      end
    end

    def access_category_form
      visit cms_categories_url
      within "#category_#{@category.id}" do
        click_on "Edit"
      end
    end
  end
end
