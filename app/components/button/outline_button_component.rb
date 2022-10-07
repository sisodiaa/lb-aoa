# frozen_string_literal: true

class Button::OutlineButtonComponent < ViewComponent::Base
  def initialize(spacing: "", color: "", typography: "", transition: "")
    @spacing = spacing
    @color = color
    @typography = typography
    @transition = transition
  end

  def before_render
    @classes = [base_classes, @spacing, @color, @typography, @transition].reject(&:empty?).join(" ")
  end

  private

  def base_classes
    "bg-transparent border focus:ring-4 focus:outline-none rounded-lg text-center"
  end
end
