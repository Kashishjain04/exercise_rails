class UsersController < ApplicationController
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
    @user = User.login_or_signup(user_params)

    respond_to do |format|
      if @user.errors.none? && @user.save
        session[:user_id] = @user.id
        format.html { redirect_to appointments_url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :preferred_currency)
  end
end
