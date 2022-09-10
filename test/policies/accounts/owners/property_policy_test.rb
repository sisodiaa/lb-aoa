require "test_helper"

class Accounts::Owners::PropertyPolicyTest < ActiveSupport::TestCase
  setup do
    @owner = owners(:confirmed_linked_owner)
    @registered_property = properties(:registered_property)
    @unregistered_property = properties(:unregistered_property)
  end

  teardown do
    @owner = @registered_property = @unregistered_property = nil
  end

  def test_edit
    assert Accounts::Owners::PropertyPolicy.new(@owner, @registered_property).edit?
    assert_not Accounts::Owners::PropertyPolicy.new(@owner, @unregistered_property).edit?
  end

  def test_update
    assert Accounts::Owners::PropertyPolicy.new(@owner, @registered_property).edit?
    assert_not Accounts::Owners::PropertyPolicy.new(@owner, @unregistered_property).edit?
  end
end
