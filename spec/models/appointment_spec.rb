require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:valid_params) {
    {
      user_id: user1.id,
      doctor_id: doctor1.id,
      date_time: doctor1.available_slots.values.first[0],
      amount_inr: 500,
      currency_rates: FixerApi.today_rates
    }
  }
  let(:invalid_params) { [
    {
      user_id: user1.id,
      doctor_id: doctor1.id,
      date_time: DateTime.now - 1.seconds,
      amount_inr: 500,
      currency_rates: FixerApi.today_rates
    },
    {
      user_id: user1.id,
      doctor_id: doctor1.id,
      date_time: doctor1.available_slots.values.first[0] + 10.minutes,
      amount_inr: 500,
      currency_rates: FixerApi.today_rates
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
      it "validates presence of amount_inr" do
        expect { Appointment.create!(**valid_params.except(:amount_inr)) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "validates presence of currency_rates" do
        expect { Appointment.create!(**valid_params.except(:currency_rates)) }
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
      expect { Appointment.create!(**valid_params, amount_inr: -1) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end

    it "throws an error if invalid currency is passed" do
      expect { Appointment.create!(
        **valid_params,
        currency_rates: FixerApi.today_rates.except("USD")
      ) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
