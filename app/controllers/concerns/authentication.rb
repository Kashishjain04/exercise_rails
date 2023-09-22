module Authentication
  def get_session_user
    user_id = session[:user_id]
    return nil if user_id.nil?

    begin
      User.find(user_id)
    rescue ActiveRecord::RecordNotFound => e
      session[:user_id] = nil
    end
  end

  def authenticate
    redirect_to login_path,
                flash: { error: "You need to login first" } if get_session_user.nil?
  end

  def login_or_signup(params)
    user = User.find_or_initialize_by(email: params[:email])
    user.update(**params)
    session[:user_id] = user.id

    user
  end
end