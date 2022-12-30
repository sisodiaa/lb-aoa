require "test_helper"

module Management
  class OwnersMembershipsFlowTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @membership = memberships(:under_review_membership)
    end

    teardown do
      @confirmed_board_admin = @membership = nil
    end

    test "accepting a membership request" do
      assert @membership.under_review?

      authenticated_admin do
        assert_emails 1 do
          patch management_membership_path(@membership), params: {
            membership: {
              transition: "approve",
              page: 2 # increemented page number to cover Pagy::OverflowError
            }
          }
        end
      end

      assert @membership.reload.approved?
    end

    test "rejecting a membership request" do
      assert @membership.under_review?

      authenticated_admin do
        assert_emails 1 do
          patch management_membership_path(@membership), params: {
            membership: {
              transition: "reject",
              remark: "a test comment for rejection",
              page: 1
            }
          }
        end
      end

      assert @membership.reload.rejected?
    end

    private

    def authenticated_admin
      sign_in @confirmed_board_admin, scope: :admin
      yield if block_given?
      sign_out :admin
    end
  end
end
