# frozen_string_literal: true

class Button::DefaultButtonComponent < ViewComponent::Base
  attr_reader :type, :variant, :size, :block

  def initialize(
    type: :button,
    variant: :primary,
    size: :base,
    icon_position: :left,
    block: false,
    data: {}
  )
    @type = type
    @variant = variant
    @size = size
    @icon_position = icon_position
    @block = block
    @data = data
  end

  def before_render
    @class_name = [block_class, size_class, variant_class].reject(&:empty?).join(" ")
  end

  renders_one :text
  renders_one :icon

  private

  def block_class
    block ? "w-full" : ""
  end

  def size_class
    return "px-3 py-1.5 text-xs" if size == :small
    "px-5 py-2.5 text-sm"
  end

  def variant_class
    case variant
    when :secondary
      secondary_variant_class
    when :success
      success_variant_class
    when :error
      error_variant_class
    else
      primary_variant_class
    end
  end

  def primary_variant_class
    "bg-lb-500 enabled:hover:bg-lb-600 enabled:active:bg-lb-700 " \
    "disabled:opacity-50 disabled:cursor-not-allowed " \
    "shadow-sm shadow-lb-100 hover:shadow-xs hover:shadow-lb-50 active:shadow-none"
  end

  def secondary_variant_class
    "bg-blue-700 enabled:hover:bg-blue-800 enabled:active:bg-blue-900 " \
    "disabled:opacity-50 disabled:cursor-not-allowed " \
    "shadow-sm shadow-blue-300 hover:shadow-xs hover:shadow-blue-100 active:shadow-none"
  end

  def success_variant_class
    "bg-emerald-600 enabled:hover:bg-emerald-700 enabled:active:bg-emerald-800 " \
    "disabled:opacity-50 disabled:cursor-not-allowed " \
    "shadow-sm shadow-emerald-200 hover:shadow-xs hover:shadow-emerald-100 active:shadow-none"
  end

  def error_variant_class
    "bg-red-600 enabled:hover:bg-red-700 enabled:active:bg-red-800 " \
    "disabled:opacity-50 disabled:cursor-not-allowed " \
    "shadow-sm shadow-red-200 hover:shadow-xs hover:shadow-red-100 active:shadow-none"
  end
end
