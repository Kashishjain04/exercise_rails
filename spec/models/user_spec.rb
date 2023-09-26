require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    let(:invalid_attributes) { {
      email: ["one@user.", "one@.com", "one@", "@user.com", "user.com"],
      name: ["1UserName", "Us", " User", "User@Name"],
      preferred_currency: ["CAD"]
    } }

    context "presence" do
      [:name, :email].each do |field|
        it { should validate_presence_of(field) }
      end
    end

    it { should have_many(:appointments) }
    it { should_not allow_values(*invalid_attributes[:email]).for(:email) }
    it { should_not allow_values(*invalid_attributes[:name]).for(:name) }
    it { should_not allow_values(*invalid_attributes[:preferred_currency]).for(:preferred_currency) }
  end

  it "does set default value of preferred_currency to 'INR'" do
    user = User.create!({email: "test@user.com", name: "Test User"})
    expect(user.preferred_currency).to eql('INR')
  end

end
