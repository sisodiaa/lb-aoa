class Post < ApplicationRecord
  include AASM

  has_many :documents, as: :documentable, dependent: :destroy

  has_rich_text :content

  enum publication_state: {
    draft: 0,
    published: 1
  }

  enum visibility_state: {
    visitors: 0,
    members: 1
  }

  validates :title, presence: true, length: {maximum: 256}
  validates :content, presence: true

  aasm(
    :publication,
    column: :publication_state,
    enum: true,
    no_direct_assignment: true
  ) do
    state :draft, initial: true
    state :published

    event :publish do
      transitions from: :draft, to: :published
    end
  end

  aasm(
    :visibility,
    column: :visibility_state,
    enum: true,
    no_direct_assignment: true
  ) do
    state :members, initial: true
    state :visitors

    # Casting can only be performed on a published post
    event :broadcast do
      transitions from: :members, to: :visitors, if: :published?
    end

    event :narrowcast do
      transitions from: :visitors, to: :members, if: :published?
    end
  end
end
