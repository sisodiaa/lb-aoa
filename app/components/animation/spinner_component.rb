# frozen_string_literal: true

class Animation::SpinnerComponent < ViewComponent::Base
  attr_reader :element

  def initialize(element: :default_button)
    @element = element
  end

  def before_render
    @class_name = [dimensions_class].reject(&:empty?).join(" ")
  end

  private

  def dimensions_class
    "h-5 w-5"
  end
end
