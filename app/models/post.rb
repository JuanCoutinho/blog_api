# app/models/post.rb
class Post < ApplicationRecord
  has_one_attached :photo

  enum feeling: { happy: 0, nostalgic: 1, grateful: 2, in_love: 3 }

  validates :title, presence: true
  validates :body, presence: true
  validates :photo, presence: true
end
