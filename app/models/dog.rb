class Dog < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :likes, dependent: :destroy

  alias_attribute :owner, :user
end
