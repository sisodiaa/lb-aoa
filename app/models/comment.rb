class Comment < ApplicationRecord
  belongs_to :author, class_name: "Owner", inverse_of: :comments, foreign_key: "owner_id"
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  has_rich_text :content

  validates :content, presence: true
end
