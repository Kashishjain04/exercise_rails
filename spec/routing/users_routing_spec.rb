require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do
    it { should route(:get, '/login').to(action: :new) }
    it { should route(:post, '/users').to(action: :create) }
  end
end
