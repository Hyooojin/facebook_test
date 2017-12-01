class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title,
    presence: true,
    length: { minimum: 1, maximum: 50}
  validates :content,
    presence: true,
    length: { minimum: 1, maximum: 200}
end
