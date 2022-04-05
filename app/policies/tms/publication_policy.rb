class TMS::PublicationPolicy < ApplicationPolicy
  def update?
    record.draft?
  end
end
