# frozen_string_literal: true

class Discussion::LinkTupleComponent < ViewComponent::Base
  renders_one :icon
  renders_one :text

  def initialize(class_name: "", path: "#", renderable: true, data: {})
    @path = path
    @class_name = class_name
    @renderable = renderable
    @data = data
  end

  def render?
    @renderable
  end
end
