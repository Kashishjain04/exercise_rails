require "rails_helper"

RSpec.describe DoctorsController, type: :routing do
  describe "routing" do
    it { should route(:get, '/').to(action: :index) }
  end
end
