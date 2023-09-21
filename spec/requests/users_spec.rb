require 'rails_helper'

RSpec.describe "/users", type: :request do
  describe "GET /new" do
    it "redirects if user is already logged in" do
      post users_path, params: { user: user1.as_json }
      expect(get new_user_path).to redirect_to(appointments_path)
    end

    describe "POST /create" do
      it "logs in the user" do
        post users_path, params: { user: user1.as_json }
        expect( session[:user_id] ).to eq(user1.id)
      end
    end
  end

end
