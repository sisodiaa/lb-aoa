require "test_helper"

module Accounts
  class OwnerAuthenticationFlowTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_linked_owner = profiles(:confirmed_linked_owner)
    end

    teardown do
      @confirmed_linked_owner = nil
    end

    test "create a new owner account" do
      assert_difference("Owner.count") do
        assert_difference("Profile.count") do
          assert_emails 1 do
            post owner_registration_path, params: {
              owner: {
                email: "new_owner@example.com",
                password: "password",
                password_confirmation: "password",
                profile_attributes: {
                  first_name: "New",
                  last_name: "Owner"
                }
              }
            }
          end
        end
      end

      assert_equal(
        "A message with a confirmation link has been sent to your email address. " \
        "Please follow the link to activate your account.",
        flash[:notice]
      )
    end
  end
end
