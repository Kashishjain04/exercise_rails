require 'rails_helper'

RSpec.describe "/appointments", type: :request do
  describe "POST /create" do
    context "with valid parameters" do
      it "should create a new Appointment" do
        expect {
          post appointments_url, params: {
            appointment: {
              doctor_id: doctor1.id,
              date_time: doctor1.available_slots.values.first[0],
              user: user1.as_json
            }
          }, as: :turbo_stream
        }.to change(Appointment, :count).by(1)
      end

      it "should log in the user who created the appointment" do
        post appointments_url, params: {
          appointment: {
            doctor_id: doctor1.id,
            date_time: doctor1.available_slots.values.first[0],
            user: user1.as_json
          }
        }, as: :turbo_stream
        expect(session[:user_id]).to eql(user1.id)
      end
    end

    context "with invalid parameters" do
      it "should not create a new Appointment for invalid doctor" do
        expect {
          post appointments_url, params: { appointment: {
            doctor_id: 0,
            date_time: doctor1.available_slots.values.first[0],
            user: user1.as_json
          } }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
