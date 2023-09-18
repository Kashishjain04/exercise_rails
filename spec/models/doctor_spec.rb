require 'rails_helper'

RSpec.describe Doctor, type: :model do
  describe "validations" do
    context "presence" do
      it "should validate presence of name" do
        expect { Doctor.create!(address: 'Address', image: '/doctors/doctor-1.png') }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "should validate presence of address" do
        expect { Doctor.create!(name: 'DoctorOne', image: '/doctors/doctor-1.png') }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "should validate presence of image" do
        expect { Doctor.create!(name: 'DoctorOne', address: 'Address') }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "available_slots" do
    before do
      Timecop.freeze(Date.today)
    end
    context "slots are available for today" do
      it "should return slots array of size: #{Doctor::MAX_DAYS}" do
        expect(doctor1.available_slots.length).to eql(Doctor::MAX_DAYS)
      end
    end

    context "today slots are booked" do
      before do
        doctor1.available_slots.values.first.each do |slot|
          Appointment.create!(
            user: user1, doctor: doctor1, date_time: slot, amount: 500, currency: 'INR'
          )
        end
      end
      it "should return slots array of size: #{Doctor::MAX_DAYS - 1}" do
        expect(doctor1.available_slots.length).to eql(Doctor::MAX_DAYS - 1)
      end
    end
  end

  describe "next_available_today" do
    before do
      Timecop.freeze(Date.today)
    end
    context "slots are available for today" do
      it "should return a string" do
        expect(doctor1.next_available_today).to be_instance_of String
      end
    end

    context "today slots are booked" do
      before do
        doctor1.available_slots.values.first.each do |slot|
          Appointment.create!(
            user: user1, doctor: doctor1, date_time: slot, amount: 500, currency: 'INR'
          )
        end
      end
      it "should return nil" do
        expect(doctor1.next_available_today).nil?
      end
    end
  end
end
