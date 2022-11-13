# frozen_string_literal: true

class Discussion::LinkTupleComponent < ViewComponent::Base
  renders_one :icon
  renders_one :text

  def initialize(path: "#", class_name:)
    @path = path
    @class_name = class_name
  end
end
