class Tender < ApplicationRecord
  include AASM

  before_validation :parameterize_token

  has_many :documents, as: :documentable, dependent: :destroy
  has_rich_text :description

  enum publication_state: {
    draft: 0,
    published: 1
  }

  enum notice_state: {
    upcoming: 0,
    current: 1,
    under_review: 2,
    archived: 3
  }

  validates :reference_id, presence: true, uniqueness: true
  validates :reference_token, presence: true, uniqueness: true
  validates :title, presence: true
  validates :description, presence: true
  validates :opens_on, presence: true
  validates :closes_on, presence: true
  validates :documents, presence: true, on: :notice_publication
  validates_with TenderTimeFrameValidator, on: :notice_publication

  aasm(
    :publication,
    column: :publication_state,
    enum: true,
    no_direct_assignment: true
  ) do
    state :draft, initial: true
    state :published

    event :publish do
      after do
        self.published_at = DateTime.current
      end

      transitions from: :draft, to: :published, if: :upcoming_tender?
    end
  end

  def to_param
    "#{id}-#{reference_id}"
  end

  def opens_on=(opens_on)
    self.opening = Time.zone.parse(opens_on)
  rescue ArgumentError
    self.opening = nil
  end

  def opens_on
    opening
  end

  def closes_on=(closes_on)
    self.closing = Time.zone.parse(closes_on)
  rescue ArgumentError
    self.closing = nil
  end

  def closes_on
    closing
  end

  private

  def parameterize_token
    self[:reference_id] = reference_token.parameterize
  end

  def upcoming_tender?
    DateTime.current <= opening
  end
end
