require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    context "presence" do
      it "should validate presence of name" do
        expect { User.create!(email: 'one@user.com', preferred_currency: 'INR') }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "should validate presence of email" do
        expect { User.create!(name: 'UserOne', preferred_currency: 'INR') }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    it "should validate uniqueness of email" do
      expect { User.create!(name: "UserOne", email: user1.email) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should throw error if invalid preferred_currency is passed" do
      expect { User.create!(name: "UserOne", email: "user@email.com", preferred_currency: "CAD") }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  it "should set default value of preferred_currency to 'INR'" do
    user = User.create!(name: 'UserOne', email: 'user@email.com')
    expect(user.preferred_currency).to eql('INR')
  end

end
