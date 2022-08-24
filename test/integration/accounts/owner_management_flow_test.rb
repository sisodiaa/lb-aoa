require "test_helper"

module Accounts
  class OwnerManagementFlowTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_linked_owner = owners(:confirmed_linked_owner)
    end

    teardown do
      @confirmed_linked_owner = nil
    end

    test "new owner account can not be created without profile information" do
      assert_difference("Owner.count", 0) do
        assert_difference("Profile.count", 0) do
          assert_emails 0 do
            post owner_registration_path, params: {
              owner: {
                email: "new_owner@example.com",
                password: "password",
                password_confirmation: "password"
              }
            }
          end
        end
      end
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

    test "send email to reset password when email is in the records" do
      assert_emails 1 do
        post owner_password_path, params: {
          owner: {
            email: @confirmed_linked_owner.email
          }
        }
      end
    end

    test "do not send email to reset password when email is not in the records" do
      assert_emails 0 do
        post owner_password_path, params: {
          owner: {
            email: "bogus_owner@example.com"
          }
        }
      end
    end

    test "resend email with confirmation instructions if owner has an account" do
      assert_emails 1 do
        post owner_confirmation_path, params: {
          owner: {
            email: "owner_four@example.com"
          }
        }
      end

      assert_redirected_to new_owner_session_path
    end

    test "do not resend email with confirmation instructions if owner is already confirmed" do
      assert_emails 0 do
        post owner_confirmation_path, params: {
          owner: {
            email: @confirmed_linked_owner.email
          }
        }
      end
    end

    test "do not resend email with confirmation instructions if owner id is bogus" do
      assert_emails 0 do
        post owner_confirmation_path, params: {
          owner: {
            email: "bogus_owner@example.com"
          }
        }
      end
    end

    test "send email to unlock account when email is in the records" do
      @confirmed_linked_owner.lock_access!

      assert_emails 1 do
        post owner_unlock_path, params: {
          owner: {
            email: @confirmed_linked_owner.email
          }
        }
      end

      assert_redirected_to new_owner_session_path
    end

    test "do not send email to unlock account if account is not locked" do
      assert_emails 0 do
        post owner_unlock_path, params: {
          owner: {
            email: @confirmed_linked_owner.email
          }
        }
      end
    end

    test "do not send email to unlock account if owner id is bogus" do
      assert_emails 0 do
        post owner_unlock_path, params: {
          owner: {
            email: "bogus_owner@example.com"
          }
        }
      end
    end
  end
end
