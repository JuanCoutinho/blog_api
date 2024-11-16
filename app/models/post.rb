# app/models/post.rb
class Post < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
end
