class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: { message: 'nie może być pusta' }

  def self.ransackable_attributes(auth_object = nil)
    %w[content user_id commentable_type commentable_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user commentable]
  end
end
