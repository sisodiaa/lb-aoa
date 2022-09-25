require "application_system_test_case"

module Front
  module Search
    class PostsTest < ApplicationSystemTestCase
      setup do
        Warden.test_mode!
        @owner_with_approved_membership = owners(:confirmed_linked_owner)
        @owner_with_under_review_membership = owners(:confirmed_linked_co_owner)
      end

      teardown do
        @owner_with_approved_membership = @owner_with_under_review_membership = nil
        Warden.test_reset!
      end

      test "search button is not shown if owner does not have an approved membership" do
        login_as @owner_with_under_review_membership, scope: :owner

        visit posts_url
        within "#main" do
          assert_no_selector "a", text: "Search"
        end

        logout :owner
      end

      test "show search modal" do
        authenticated_owner do
          visit posts_url
          assert_no_selector "[aria-modal='true']"

          click_link "Search"
          assert_selector "[aria-modal='true']"
        end
      end

      test "show validation error messages" do
        authenticated_owner do
          visit posts_url
          click_link "Search"

          within "#new_front_search_post_form" do
            fill_in "tags_list", with: "first, second, third, fourth"
            fill_in "start_date", with: "2022-03-20"
            fill_in "end_date", with: "2022-03-10"
            click_on "Search"

            assert_selector "#error_explanation li", text: "Start date should be before end date"
            assert_selector "#error_explanation li", text: "Tags list should not have more than 3 tags"
        end
        end
      end

      test "that cancel button closes the modal" do
        authenticated_owner do
          visit posts_url
          click_link "Search"
          assert_selector "[aria-modal='true']"

          within "#new_front_search_post_form" do
            click_on "Cancel"
          end

          assert_no_selector "[aria-modal='true']"
        end
      end

      test "perform a search" do
        authenticated_owner do
          visit posts_url
          click_link "Search"

          within "#new_front_search_post_form" do
            select "policy", from: "category_id"
            click_on "Search"
          end

          assert_no_selector "[aria-modal='true']"

          within "#main" do
            assert_selector "a[data-turbo-frame='modal']", text: "Refine Search"

            within "#results" do
              assert_selector ".post", count: 2
            end

            click_link "Refine Search"
          end

          within "#new_front_search_post_form" do
            assert_selector "select#category_id", text: "Policy"
          end
        end
      end

      test "pagination of results" do
        authenticated_owner do
          visit posts_url
          click_link "Search"

          within "#new_front_search_post_form" do
            click_on "Search"
          end

          within "#results" do
            assert_selector ".post", count: 6
            click_on "Next"
          end

          within "#results" do
            assert_selector ".post", count: 3
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
end
