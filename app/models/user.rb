class User < ApplicationRecord
  has_many :dogs
  has_many :likes, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Public - Returns True/False depending on whether the User has a like for given dog.
  def likes?(dog_id)
    Like.where(user_id: self.id, dog_id: dog_id).present?
  end
end
