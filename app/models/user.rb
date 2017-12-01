class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email,
    presence: true,
    uniqueness: true,
    format: {with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/}
end
