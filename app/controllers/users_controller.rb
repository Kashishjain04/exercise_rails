class UsersController < ApplicationController
  include Authentication

  # GET /users/new
  def new
    user = get_session_user
    if user
      redirect_to appointments_path, notice: 'Already logged in'
      return
    end
    @user = User.new
  end

  # POST /users or /users.json
  def create
    @user = login_or_signup(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to appointments_url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :preferred_currency)
  end
end
