require 'rails_helper'

RSpec.describe Doctor, type: :model do
  let(:invalid_attributes) { {
    name: ["1DoctorName", "Doct", " Doctor", "Doctor@Name"],
    address: ["Addr"],
    image: ["doctors.txt", "doctors/jpg", "doctors", "doctors."],
    working_timestamps: [
      {
        **doctor.as_json,
        start_time: Time.now,
        break_start_time: Time.now,
        break_end_time: Time.now,
        end_time: Time.now
      },
      {
        **doctor.as_json,
        start_time: Time.now + 30.minutes,
        break_start_time: Time.now + 20.minutes,
        break_end_time: Time.now + 40.minutes,
        end_time: Time.now + 1.hours
      },
      {
        **doctor.as_json,
        start_time: Time.now,
        break_start_time: Time.now + 40.minutes,
        break_end_time: Time.now + 30.minutes,
        end_time: Time.now + 1.hours
      },
      {
        **doctor.as_json,
        start_time: Time.now,
        break_start_time: Time.now + 20.minutes,
        break_end_time: Time.now + 80.minutes,
        end_time: Time.now + 1.hours
      },
    ]
  } }

  describe "validations" do
    subject { doctor }

    context "presence" do
      [:name, :address, :image].each do |field|
        it { should validate_presence_of(field) }
      end
    end

    it { should have_many(:appointments) }
    it { should_not allow_values(*invalid_attributes[:name]).for(:name) }
    it { should_not allow_values(*invalid_attributes[:address]).for(:address) }
    it { should_not allow_values(*invalid_attributes[:image]).for(:image) }

    it "should not allow invalid set of working timestamps" do
      invalid_attributes[:working_timestamps].each do |attr|
        expect { Doctor.create!(attr) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "available_slots" do
    context "slots are available for today" do
      it "returns slots array of size: #{Doctor::DOCTOR_MAXIMUM_AVAILABILITY}" do
        expect(doctor.available_slots.length).to eql(Doctor::DOCTOR_MAXIMUM_AVAILABILITY)
      end
    end

    context "all slots are booked for today" do
      before do
        doctor.available_slots.values.first.each do |slot|
          Appointment.create(
            user: user, doctor: doctor, date_time: slot,
            amount_inr: 500, currency_rates: FixerApi.today_rates
          )
        end
      end

      it "returns slots array of size: #{Doctor::DOCTOR_MAXIMUM_AVAILABILITY - 1}" do
        expect(doctor.available_slots.length).to eql(Doctor::DOCTOR_MAXIMUM_AVAILABILITY - 1)
      end
    end
  end

  describe "next_available_today" do
    context "slots are available for today" do
      it "returns a string" do
        expect(doctor.next_available_today).to be_instance_of String
      end
    end

    context "all slots are booked for today" do
      before do
        doctor.available_slots.values.first.each do |slot|
          Appointment.create!(
            user: user, doctor: doctor, date_time: slot,
            amount_inr: 500, currency_rates: FixerApi.today_rates
          )
        end
      end

      it "returns nil" do
        expect(doctor.next_available_today).nil?
      end
    end
  end
end
