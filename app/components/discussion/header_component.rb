# frozen_string_literal: true

class Discussion::HeaderComponent < ViewComponent::Base
  renders_one :icon
  renders_one :heading, Discussion::HeadingComponent

  def initialize(render_icon:)
    @render_icon = render_icon
  end

  def renderable?
    @render_icon
  end
end
