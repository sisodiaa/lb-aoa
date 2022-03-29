class CMS::PublicationPolicy < ApplicationPolicy
  def update?
    record.draft?
  end
end
