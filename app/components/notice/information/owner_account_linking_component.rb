# frozen_string_literal: true

class Notice::Information::OwnerAccountLinkingComponent < Notice::InformationComponent
  def initialize(user:, id:)
    super(spacing: "p-4 mb-8", color: "border-blue-300 bg-blue-50")
    @user = user
    @id = id
  end

  def render?
    @user.unlinked?
  end
end
