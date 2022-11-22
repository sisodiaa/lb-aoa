class Comment < ApplicationRecord
  belongs_to :author, class_name: "Owner", inverse_of: :comments, foreign_key: "owner_id"
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  before_create :set_comment_token
  after_save :increment_commentable_comments_total

  has_rich_text :content

  validates :content, presence: true

  def to_param
    comment_token
  end

  def root_discussion
    return commentable if commentable.instance_of?(Discussion)
    commentable.root_discussion
  end

  private

  def set_comment_token
    self.comment_token = generate_comment_token
  end

  def generate_comment_token
    loop do
      comment_token = SecureRandom.hex(4)
      break comment_token unless Comment.where(comment_token: comment_token).exists?
    end
  end

  def increment_commentable_comments_total
    commentable.comments_total += 1
    commentable.save!
  end
end
