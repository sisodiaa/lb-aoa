require "application_system_test_case"

module Front
  module Search
    class PostsTest < ApplicationSystemTestCase
      test "show search modal" do
        visit posts_url
        assert_no_selector "[aria-modal='true']"

        click_link "Search"
        assert_selector "[aria-modal='true']"
      end

      test "show validation error messages" do
        visit posts_url
        click_link "Search"

        within "#new_front_search_post_form" do
          fill_in "tags_list", with: "first, second, third, fourth"
          fill_in "start_date", with: "2022-03-20"
          fill_in "end_date", with: "2022-03-10"
          click_on "Search"

          assert_selector "#error_explanation li", text: "Start date should be before end date"
          assert_selector "#error_explanation li", text: "Tags should be 3 or lesser"
        end
      end

      test "that cancel button closes the modal" do
        visit posts_url
        click_link "Search"
        assert_selector "[aria-modal='true']"

        within "#new_front_search_post_form" do
          click_on "Cancel"
        end

        assert_no_selector "[aria-modal='true']"
      end

      test "perform a search" do
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
  end
end
