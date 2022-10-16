# frozen_string_literal: true

class Link::DefaultButtonComponent < ViewComponent::Base
  attr_reader :variant, :size, :block

  def initialize(href: "#", variant: :primary, size: :base, icon_position: :left, block: false)
    @href = href
    @variant = variant
    @size = size
    @icon_position = icon_position
    @block = block
  end

  def before_render
    @class_name = [block_class, size_class, variant_class].reject(&:empty?).join(" ")
  end

  renders_one :text
  renders_one :icon

  private

  def block_class
    return "w-full" if block
    ""
  end

  def size_class
    return "px-3 py-1.5 text-xs" if size == :small
    "px-5 py-2.5 text-sm"
  end

  def variant_class
    return secondary_variant_class if variant == :secondary
    return success_variant_class if variant == :success
    return error_variant_class if variant == :error
    primary_variant_class
  end

  def primary_variant_class
    "bg-lb-500 hover:bg-lb-600 active:bg-lb-700 " \
    "shadow-sm shadow-lb-100 hover:shadow-xs hover:shadow-lb-50 active:shadow-none"
  end

  def secondary_variant_class
    "bg-blue-700 hover:bg-blue-800 active:bg-blue-900 " \
    "shadow-sm shadow-blue-300 hover:shadow-xs hover:shadow-blue-100 active:shadow-none"
  end

  def success_variant_class
    "bg-emerald-600 hover:bg-emerald-700 active:bg-emerald-800 " \
    "shadow-sm shadow-emerald-200 hover:shadow-xs hover:shadow-emerald-100 active:shadow-none"
  end

  def error_variant_class
    "bg-red-600 hover:bg-red-700 active:bg-red-800 " \
    "shadow-sm shadow-red-200 hover:shadow-xs hover:shadow-red-100 active:shadow-none"
  end
end
