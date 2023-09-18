require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:valid_params) {
    {
      user_id: user1.id,
      doctor_id: doctor1.id,
      date_time: doctor1.available_slots.values.first[0],
      amount: 500,
      currency: 'INR'
    }
  }
  let(:invalid_params) { [
    {
      user_id: user1.id,
      doctor_id: doctor1.id,
      date_time: DateTime.now - 1.seconds,
      amount: 500,
      currency: 'INR'
    },
    {
      user_id: user1.id,
      doctor_id: doctor1.id,
      date_time: doctor1.available_slots.values.first[0] + 10.minutes,
      amount: 500,
      currency: 'INR'
    }
  ] }

  describe "validations" do
    context "presence" do
      it "validates presence of doctor" do
        expect { Appointment.create!(**valid_params.except(:doctor_id)) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "validates presence of user" do
        expect { Appointment.create!(**valid_params.except(:user_id)) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "validates presence of date_time" do
        expect { Appointment.create!(**valid_params.except(:date_time)) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "validates presence of amount" do
        expect { Appointment.create!(**valid_params.except(:amount)) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "validates presence of currency" do
        expect { Appointment.create!(**valid_params.except(:currency)) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    it "throws an error for past date_time" do
      expect { Appointment.create!(**invalid_params[0]) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end

    it "throws an error if date_time is not in doctor's slots" do
      expect { Appointment.create!(**invalid_params[1]) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end

    it "throws an error if invalid amount is passed" do
      expect { Appointment.create!(**valid_params, amount: -1) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end

    it "throws an error if invalid currency is passed" do
      expect { Appointment.create!(**valid_params, currency: "CAD") }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
