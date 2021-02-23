class LikesController < ApplicationController
  before_action :find_dog

  def create
    if !already_liked? && !current_user_is_owner?
      @dog.likes.create(user_id: current_user.id)
      redirect_back(fallback_location: root_path)
    else
      render json: { message: "Looks like you alredy liked this dog or are the owner of this dog." }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def find_dog
    @dog = Dog.find(params[:dog_id])
  end

  # Checks if the current user already added a Like to the dog.
  def already_liked?
    Like.where(user_id: current_user.id, dog_id: params[:dog_id]).exists?
  end

  # Checks if the current user is the owner of the dog.
  def current_user_is_owner?
    @dog.owner == current_user
  end
end
