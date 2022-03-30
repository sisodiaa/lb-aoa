require "test_helper"

module CMS
  class CategoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @category = categories(:horticulture)
    end

    teardown do
      @category = @confirmed_board_admin = nil
    end

    test "#authenticate_admin!" do
      get cms_categories_path
      assert_redirected_to new_admin_session_path
    end

    test "should get index" do
      authenticated_admin do
        get cms_categories_path
        assert_response :success
      end
    end

    test "should get new" do
      authenticated_admin do
        get new_cms_category_path
        assert_response :success
      end
    end

    test "should create post" do
      authenticated_admin do
        assert_difference "Category.count" do
          post cms_categories_path, params: {
            category: {
              name: "Meeting"
            }
          }
        end

        assert_redirected_to cms_categories_path
      end
    end

    test "return unprocessable_entity if post can not be created" do
      authenticated_admin do
        post cms_categories_path, params: {
          category: {
            name: ""
          }
        }

        assert_response :unprocessable_entity
      end
    end

    test "should get edit" do
      authenticated_admin do
        get edit_cms_category_path(@category)
        assert_response :success
      end
    end

    test "should update post" do
      assert_equal "horticulture", @category.name

      authenticated_admin do
        patch cms_category_path(@category), params: {
          category: {
            name: "new name"
          }
        }
      end

      assert_equal "new name", @category.reload.name
      assert_redirected_to cms_categories_path
    end

    test "return unprocessable_entity if post can not be updated" do
      authenticated_admin do
        patch cms_category_path(@category), params: {
          category: {
            name: ""
          }
        }

        assert_response :unprocessable_entity
      end
    end

    private

    def authenticated_admin
      sign_in @confirmed_board_admin, scope: :admin
      yield if block_given?
      sign_out :admin
    end
  end
end
