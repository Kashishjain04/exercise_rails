require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) {
    {
      name: "UserOne",
      email: "user@one.com",
    }
  }

  describe "validations" do
    let(:invalid_attributes) { {
      not_name: {
        email: "one@user.com"
      },
      not_email: {
        name: "UserOne"
      },
      invalid_currency: {
        name: "UserOne",
        email: "one@user.com",
        preferred_currency: "CAD"
      },
      invalid_name: [
        {
          name: "1UserName",
          email: "one@user.com"
        },
        {
          name: "User",
          email: "one@user.com"
        },
        {
          name: " User",
          email: "one@user.com"
        },
        {
          name: "User@Name",
          email: "one@user.com"
        },
      ],
      invalid_email: [
        {
          name: "UserOne",
          email: "one@user."
        },
        {
          name: "UserOne",
          email: "one@.com"
        },
        {
          name: "UserOne",
          email: "one@"
        },
        {
          name: "UserOne",
          email: "@user.com"
        },
        {
          name: "UserOne",
          email: "user.com"
        }
      ]
    } }
    context "presence" do
      it "validates presence of name" do
        expect { User.create!(invalid_attributes[:not_name]) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "validates presence of email" do
        expect { User.create!(invalid_attributes[:not_email]) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "email" do
      context "valid parameters" do
        it "allows valid formatted email" do
          expect { User.create!(valid_attributes) }.to change(User, :count).by(1)
        end
      end

      context "invalid parameters" do
        it "throws error if invalid email is passed" do
          invalid_attributes[:invalid_email].each do |attr|
            expect { User.create!(attr) }
              .to raise_error(ActiveRecord::RecordInvalid)
          end
        end
        it "throws error if email is already taken" do
          expect { User.create!(name: "UserOne", email: user1.email) }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context "name" do
      context "valid parameters" do
        it "allows valid formatted name" do
          expect { User.create!(valid_attributes) }.to change(User, :count).by(1)
        end
      end

      context "invalid parameters" do
        it "throws error if invalid name is passed" do
          invalid_attributes[:invalid_name].each do |attr|
            expect { User.create!(attr) }
              .to raise_error(ActiveRecord::RecordInvalid)
          end
        end
      end
    end

    it "throws an error if invalid preferred_currency is passed" do
      expect { User.create!(invalid_attributes[:invalid_currency]) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  it "does set default value of preferred_currency to 'INR'" do
    user = User.create!(valid_attributes)
    expect(user.preferred_currency).to eql('INR')
  end

end
