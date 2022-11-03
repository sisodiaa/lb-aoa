class Discussion < ApplicationRecord
  include AASM

  belongs_to :owner, inverse_of: :discussions

  before_create :set_discussion_token

  enum accessibility_state: {
    unlocked: 0,
    locked: 1
  }

  has_rich_text :description

  validates :subject, presence: true, length: {maximum: 256}
  validates :description, presence: true

  aasm column: :accessibility_state, enum: true, no_direct_assignment: true do
    state :unlocked, initial: true
    state :locked

    event :lock do
      transitions from: :unlocked, to: :locked
    end

    event :unlock do
      transitions from: :locked, to: :unlocked
    end
  end

  def to_param
    discussion_token
  end

  private

  def set_discussion_token
    self.discussion_token = generate_discussion_token
  end

  def generate_discussion_token
    loop do
      discussion_token = SecureRandom.hex(4)
      break discussion_token unless Discussion.where(discussion_token: discussion_token).exists?
    end
  end
end
