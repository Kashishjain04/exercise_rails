class ApplicationController < ActionController::Base
  def get_session_user
    user_id = session[:user_id]
    begin
      user_id ? User.find(user_id) : nil
    rescue ActiveRecord::RecordNotFound => e
      session[:user_id] = nil
    end
  end

  def render_404
    respond_to do |format|
      format.any { render :file => "#{Rails.root}/public/404.html", :layout => false, :status => :not_found }
    end
  end
end
