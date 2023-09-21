require "rails_helper"

RSpec.describe DoctorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/doctors").to route_to("doctors#index")
    end
  end
end
