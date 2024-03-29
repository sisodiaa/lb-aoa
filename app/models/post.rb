class Post < ApplicationRecord
  include AASM

  belongs_to :category, inverse_of: :posts
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_rich_text :content

  enum publication_state: {
    draft: 0,
    published: 1
  }

  enum visibility_state: {
    members: 0,
    visitors: 1,
  }

  validates :title, presence: true, length: {maximum: 256}
  validates :content, presence: true
  validates :category, presence: true
  validate :number_of_tags

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

    # Classification can only be performed on a published post
    event :classify do
      transitions from: :visitors, to: :members, if: :published?
    end

    event :declassify do
      transitions from: :members, to: :visitors, if: :published?
    end
  end

  def toggle_visibility
    return classify if visitors?
    declassify
  end

  def tags_list
    tags.pluck(:name).join(", ")
  end

  def tags_list=(tag_names_string)
    Prosopite.pause if development_or_test_environment?
    self.tags = tag_names_string.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
    Prosopite.resume if development_or_test_environment?
  end

  def number_of_tags
    errors.add(:tags_list, "should not have more than 5 tags") if tags.length > 5
  end

  # Scopes
  scope :for_approved_members, -> { includes(:category, :rich_text_content).published }
  scope :for_visitors, -> { for_approved_members.visitors }
  scope :ordered_by_published_date, -> { order(published_at: :desc) }

  # Query methods

  def self.published_between(start_date, end_date)
    end_date += 1.day if end_date.present?
    where(published_at: start_date..end_date)
  end

  def self.with_category(category_id)
    where(categories: {id: category_id})
  end

  def self.with_tags(tags)
    where(tags: {name: tags})
  end

  private

  def development_or_test_environment?
    Rails.env.development? || Rails.env.test?
  end
end
