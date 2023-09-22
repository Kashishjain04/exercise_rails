require "rails_helper"

RSpec.describe AppointmentsController, type: :routing do
  describe "routing" do
    it { should route(:get, '/appointments').to(action: :index) }
    it { should route(:get, '/appointments/new').to(action: :new) }
    it { should route(:get, '/appointments/1').to(action: :show, id: 1) }
    it { should route(:post, '/appointments').to(action: :create) }
    it { should route(:delete, '/appointments/1').to(action: :destroy, id: 1) }
  end
end
