# frozen_string_literal: true

class Notice::HeaderComponent < ViewComponent::Base
  renders_one :icon
  renders_one :title
end
