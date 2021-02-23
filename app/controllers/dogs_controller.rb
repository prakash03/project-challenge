class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]

  # GET /dogs
  # GET /dogs.json
  def index
    if params[:order] == "Most Likes in last Hour"
      @dogs = Dog.left_joins(:likes)
                 .group(:id)
                 .order("COUNT(likes.id) DESC")
                 .where("likes.created_at >= ?", 1.hour.ago)
      @dogs = @dogs + Dog.where.not(id: @dogs.pluck(:id))
      @dogs = @dogs.paginate(:page => params[:page], :per_page=>5)
    else
      @dogs = Dog.paginate(:page => params[:page], :per_page=>5)
    end
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    @dog.owner = current_user

    respond_to do |format|
      if @dog.save
        params[:dog][:images].each do |image|
          @dog.images.attach(image)
        end

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if curent_user_authorized?
        if @dog.update(dog_params)
          if params[:dog][:images].present?
            params[:dog][:images].each do |image|
              @dog.images.attach(image)
            end
          end

          format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
          format.json { render :show, status: :ok, location: @dog }
        else
          format.html { render :edit }
          format.json { render json: @dog.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @dog, notice: 'Dog cannot be edited.' }
        format.json { render json: @dog.errors, status: :unauthorized }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images)
    end

    # Checks if the current logged in user is the owner of the dog.
    #
    # Returns - True when the logged in user is the owner. False otherwise.
    def curent_user_authorized?
      current_user == @dog.owner
    end
end
