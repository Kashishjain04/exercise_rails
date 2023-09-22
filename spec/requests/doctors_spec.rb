require 'rails_helper'

RSpec.describe "/doctors", type: :request do
  describe "GET /index" do
    before do
      get doctors_url
    end
    it { should render_template("doctors/index") }
  end
end
