class ApplicationController < ActionController::Base
  def render_404
    respond_to do |format|
      format.any { render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404 }
    end
  end
end
