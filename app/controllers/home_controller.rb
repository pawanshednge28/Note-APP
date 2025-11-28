class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @note = Note.new
    @notes = current_user.notes.order(created_at: :desc)
  end

  def profile
    @user = current_user # assuming Devise or your own auth system
  end

  def update_profile
    @user = current_user
    
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile updated successfully!"
    else
      flash.now[:alert] = "Update failed."
      render :profile, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar)
  end


end
