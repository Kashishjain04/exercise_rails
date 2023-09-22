require 'rails_helper'

RSpec.describe "/appointments", type: :request do
  include AppointmentHelpers

  describe "GET /index" do
    subject { get appointments_path }

    context "user not logged in" do
      it { should redirect_to(login_path) }
    end

    context "user logged in" do
      before do
        post users_url params: {
          user: user.as_json
        }
      end

      it { should render_template('appointments/index') }
    end
  end

  describe "POST /create" do
    subject { create_appointment }
    it "creates a new Appointment" do
      expect { subject }.to change(Appointment, :count).by(1)
    end

    it "logs in the user who created the appointment" do
      subject
      expect(session[:user_id]).to eql(user.id)
    end

    it "sends booking email to the user" do
      expect { subject }
        .to have_enqueued_mail(AppointmentMailer, :booked)
    end

    it "sends receipt email to the user" do
      expect { subject }
        .to have_enqueued_mail(AppointmentMailer, :receipt)
              .at(doctor.available_slots.values.first.first + Appointment::COMPLETION_MAIL_DELIVERY)
    end
  end

  describe "DELETE /delete" do
    before do
      @appointment = create(:appointment, user_id: user.id)
      Timecop.freeze(@appointment.date_time - (Appointment::CANCEL_DEADLINE + 1.minute))
    end

    subject { delete appointment_url @appointment }

    context "user logged in" do
      before do
        post users_url params: {
          user: user.as_json
        }
      end

      context "appointment belongs to the user" do
        it "deletes a valid appointment" do
          expect { subject }.to change(Appointment, :count).by(-1)
        end

        it "sends email to the user" do
          expect { subject }.to have_enqueued_mail(AppointmentMailer, :cancelled)
        end
      end

      context "appointment does not belong to the user" do
        before do
          user2 = create(:user, email: "another@user.com")
          post users_url params: {
            user: user2.as_json
          }
        end

        it "should respond with 404" do
          subject
          expect(response.status).to eq(404)
        end
      end

      context "appointment is scheduled for less than 30 minutes" do
        before do
          Timecop.freeze(@appointment.date_time - (Appointment::CANCEL_DEADLINE - 1.minute))
          subject
        end

        it { should redirect_to(appointments_path) }
      end
    end

    context "user not logged in" do
      it { should redirect_to login_path }
    end
  end

  describe "SHOW /show" do
    before do
      @appointment = create(:appointment, user_id: user.id)
    end

    context "user logged in" do
      before do
        post users_path, params: {
          user: user.as_json
        }
      end

      context "appointment belongs to the user" do
        it do
          get appointment_path @appointment
          should render_template("appointments/show")
        end

        it "prints the receipt in csv" do
          get appointment_path @appointment, format: :csv
          expect (response.header["Content-Disposition"]).match("receipt-#{@appointment.id}.csv")
        end

        it "prints the receipt in txt" do
          get appointment_path @appointment, format: :txt
          expect (response.header["Content-Disposition"]).match("receipt-#{@appointment.id}.txt")
        end

        it "prints the receipt in pdf" do
          get appointment_path @appointment, format: :pdf
          expect (response.header["Content-Disposition"]).match("receipt-#{@appointment.id}.pdf")
        end
      end

      context "appointment does not belong to the user" do
        before do
          user2 = create(:user, email: "another@user.com")
          post users_url params: {
            user: user2.as_json
          }
        end

        it "should respond with 404" do
          get appointment_path @appointment
          expect(response.status).to eq(404)
        end
      end

    end

    context "user not logged in" do
      it "redirects to login page" do
        expect(
          get appointment_path @appointment, format: :csv
        ).to redirect_to(login_path)
        expect(
          get appointment_path @appointment, format: :txt
        ).to redirect_to(login_path)
        expect(
          get appointment_path @appointment, format: :pdf
        ).to redirect_to(login_path)
      end
    end
  end
end
