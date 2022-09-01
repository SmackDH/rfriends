class FriendsController < ApplicationController
  before_action :set_friend, only: %i[show edit update destroy]
  # if the user is not authenticated, only let them see index and show.
  before_action :authenticate_user!, only: %i[index show]
  # before you run any of the given functions (only), check the correct user first.
  before_action :correct_user, only: %i[edit update destroy]

  # GET /friends or /friends.json
  def index
    @friends = Friend.all
  end

  # GET /friends/1 or /friends/1.json
  def show
  end

  # GET /friends/new
  def new
    # @friend = Friend.new
    @friend = current_user.friends.build
  end

  # GET /friends/1/edit
  def edit
  end

  # POST /friends or /friends.json
  def create
    # @friend = Friend.new(friend_params)
    @friend = current_user.friends.build(friend_params)

    respond_to do |format|
      if @friend.save
        format.html do
          redirect_to friend_url(@friend),
                      notice: "Friend was successfully created."
        end
        format.json { render :show, status: :created, location: @friend }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @friend.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /friends/1 or /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params)
        format.html do
          redirect_to friend_url(@friend),
                      notice: "Friend was successfully updated."
        end
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @friend.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /friends/1 or /friends/1.json
  def destroy
    @friend.destroy

    respond_to do |format|
      format.html do
        redirect_to friends_url, notice: "Friend was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end


  # The correct user = the current user that has been associated with this id.
  # Error message if this is not correct / you will be given a message.
  def correct_user
    @friend = current_user.friends.find_by(id: params[:id])
    redirect_to friends_path, notice: "Not authorized to edit this friend" if @friend.nil?
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_friend
    @friend = Friend.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def friend_params
    params.require(:friend).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :twitter,
      :user_id
    )
  end
end
