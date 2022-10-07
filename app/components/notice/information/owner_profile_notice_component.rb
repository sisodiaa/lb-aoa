# frozen_string_literal: true

class Notice::Information::OwnerProfileNoticeComponent < Notice::InformationComponent
  def initialize(profile:, id:)
    super(spacing: "p-4 mb-8", color: "border-blue-300 bg-blue-50")
    @profile = profile
    @id = id
  end

  def render?
   !@profile.complete?
  end
end
