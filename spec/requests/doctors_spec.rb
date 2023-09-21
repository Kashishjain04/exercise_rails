require 'rails_helper'

RSpec.describe "/doctors", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      get doctors_url
      expect(response).to be_successful
    end
  end
end
