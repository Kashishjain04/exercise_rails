require 'rails_helper'

RSpec.describe Doctor, type: :model do
  let(:valid_attributes) { {
    name: "DoctorOne",
    address: "Address",
    image: "/doctors/doctor-1.png"
  } }
  let(:invalid_attributes) { {
    not_name: {
      address: "Address",
      image: "/doctors/doctor-1.png"
    },
    not_address: {
      name: "DoctorOne",
      image: "/doctors/doctor-1.png"
    },
    not_image: {
      name: "DoctorOne",
      address: "Address",
    },
    invalid_name: [
      {
        name: "1DoctorName",
        address: "Address",
        image: "/doctors/doctor-1.png"
      },
      {
        name: "Doct",
        address: "Address",
        image: "/doctors/doctor-1.png"
      },
      {
        name: " Doctor",
        address: "Address",
        image: "/doctors/doctor-1.png"
      },
      {
        name: "Doctor@Name",
        address: "Address",
        image: "/doctors/doctor-1.png"
      },
    ],
    invalid_address: {
      name: "DoctorOne",
      address: "Addr",
      image: "/doctors/doctor-1.png"
    },
    invalid_image: [
      {
        name: "DoctorOne",
        address: "Address",
        image: "doctors.txt"
      },
      {
        name: "DoctorOne",
        address: "Address",
        image: "doctors/jpg"
      },
      {
        name: "DoctorOne",
        address: "Address",
        image: "doctors"
      },
      {
        name: "DoctorOne",
        address: "Address",
        image: "doctors."
      },
    ],
    working_timestamps: [
      {
        name: "DoctorOne",
        address: "Address",
        image: "/doctors/doctor-1.png",
        start_time: Time.now,
        break_start_time: Time.now,
        break_end_time: Time.now,
        end_time: Time.now
      },
      {
        name: "DoctorOne",
        address: "Address",
        image: "/doctors/doctor-1.png",
        start_time: Time.now + 30.minutes,
        break_start_time: Time.now + 20.minutes,
        break_end_time: Time.now + 40.minutes,
        end_time: Time.now + 1.hours
      },
      {
        name: "DoctorOne",
        address: "Address",
        image: "/doctors/doctor-1.png",
        start_time: Time.now,
        break_start_time: Time.now + 40.minutes,
        break_end_time: Time.now + 30.minutes,
        end_time: Time.now + 1.hours
      },
      {
        name: "DoctorOne",
        address: "Address",
        image: "/doctors/doctor-1.png",
        start_time: Time.now,
        break_start_time: Time.now + 20.minutes,
        break_end_time: Time.now + 80.minutes,
        end_time: Time.now + 1.hours
      },
    ]
  } }
  describe "validations" do
    it "creates the doctor if valid values are passed" do
      expect { Doctor.create!(valid_attributes) }
        .to change(Doctor, :count).by(1)
    end

    context "presence" do
      it "validates presence of name" do
        expect { Doctor.create!(invalid_attributes[:not_name]) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "validates presence of address" do
        expect { Doctor.create!(invalid_attributes[:not_address]) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
      it "validates presence of image" do
        expect { Doctor.create!(invalid_attributes[:not_image]) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "name" do
      it "throws error if invalid name is passed" do
        invalid_attributes[:invalid_name].each do |attr|
          expect { Doctor.create!(attr) }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context "address" do
      it "throws error if invalid address is passed" do
        expect { Doctor.create!(invalid_attributes[:invalid_address]) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "image" do
      it "throws error if invalid image is passed" do
        invalid_attributes[:invalid_image].each do |attr|
          expect { Doctor.create!(attr) }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context "working timestamps" do
      before do
        Timecop.freeze
      end
      it "throws error if invalid set of working timestamps are passed" do
        invalid_attributes[:working_timestamps].each do |attr|
          expect { Doctor.create!(attr) }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  describe "available_slots" do
    before do
      Timecop.freeze(Date.today)
    end
    context "slots are available for today" do
      it "returns slots array of size: #{Doctor::MAX_DAYS}" do
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
      it "returns slots array of size: #{Doctor::MAX_DAYS - 1}" do
        expect(doctor1.available_slots.length).to eql(Doctor::MAX_DAYS - 1)
      end
    end
  end

  describe "next_available_today" do
    before do
      Timecop.freeze(Date.today)
    end
    context "slots are available for today" do
      it "returns a string" do
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
      it "returns nil" do
        expect(doctor1.next_available_today).nil?
      end
    end
  end
end
