require 'rails_helper'

RSpec.describe "/appointments", type: :request do
  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Appointment" do
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

      it "does log in the user who created the appointment" do
        post appointments_url, params: {
          appointment: {
            doctor_id: doctor1.id,
            date_time: doctor1.available_slots.values.first[0],
            user: user1.as_json
          }
        }, as: :turbo_stream
        expect(session[:user_id]).to eql(user1.id)
      end

      it "sends booking email to the user" do
        expect { post appointments_url, params: {
          appointment: {
            doctor_id: doctor1.id,
            date_time: doctor1.available_slots.values.first[0],
            user: user1.as_json
          }
        }, as: :turbo_stream }.to have_enqueued_mail(AppointmentMailer, :booked)
      end

      it "sends receipt email to the user" do
        expect { post appointments_url, params: {
          appointment: {
            doctor_id: doctor1.id,
            date_time: doctor1.available_slots.values.first[0],
            user: user1.as_json
          }
        }, as: :turbo_stream }
          .to have_enqueued_mail(AppointmentMailer, :completed)
                .at(doctor1.available_slots.values.first[0] + 2.hours)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Appointment for invalid doctor" do
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
