class ApplicationController < ActionController::Base
  def get_session_user
    user_id = session[:user_id]
    user_id ? User.find(user_id) : nil
  end

  def render_404
    respond_to do |format|
      format.any  { render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found }
    end
  end
end
