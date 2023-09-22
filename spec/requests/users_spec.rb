require 'rails_helper'

RSpec.describe "/users", type: :request do
  describe "GET /new" do
    subject { get new_user_path }

    it { should render_template("users/new") }

    context "user is already logged in" do
      before do
        post users_path, params: { user: user.as_json }
      end

      it { should redirect_to(appointments_path) }
    end
  end

  describe "POST /create" do
    before do
      post users_path, params: { user: user.as_json }
    end

    it "logs in the user" do
      expect(session[:user_id]).to eq(user.id)
    end
  end
end
