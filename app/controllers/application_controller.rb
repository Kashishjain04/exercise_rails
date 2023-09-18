class ApplicationController < ActionController::Base
  def get_session_user
    user_id = session[:user_id]
    user_id ? User.find(user_id) : nil
  end
end
