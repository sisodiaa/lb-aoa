require "test_helper"

class Accounts::Owners::PropertyPolicyTest < ActiveSupport::TestCase
  setup do
    @owner = owners(:confirmed_linked_owner)
    @owners_property = properties(:registered_property)
    @different_owner = owners(:confirmed_linked_co_owner)
  end

  teardown do
    @owner = @different_owners_property = nil
  end

  def test_show
    assert Accounts::Owners::PropertyPolicy.new(@owner, @owners_property).show?
    assert_not Accounts::Owners::PropertyPolicy.new(@different_owner, @owners_property).show?
  end

  def test_edit
    assert Accounts::Owners::PropertyPolicy.new(@owner, @owners_property).edit?
    assert_not Accounts::Owners::PropertyPolicy.new(@different_owner, @owners_property).edit?
  end

  def test_update
    assert Accounts::Owners::PropertyPolicy.new(@owner, @owners_property).update?
    assert_not Accounts::Owners::PropertyPolicy.new(@different_owner, @owners_property).update?
  end
end
