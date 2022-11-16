# frozen_string_literal: true

class Discussion::LinkTupleComponent < ViewComponent::Base
  renders_one :icon
  renders_one :text

  def initialize(class_name: "", path: "#", renderable: true)
    @path = path
    @class_name = class_name
    @renderable = renderable
  end

  def render?
    @renderable
  end
end
