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
                .at(doctor1.available_slots.values.first[0] + Appointment::COMPLETION_MAIL_DELIVERY)
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

  describe "DELETE /delete" do
    before do
      @appointment1 = create(:appointment, user_id: user1.id)
      Timecop.freeze(@appointment1.date_time - (Appointment::CANCEL_DEADLINE + 1.minute))
    end

    context "user logged in" do
      before do
        post users_url params: {
          user: user1.as_json
        }
      end
      context "valid params" do
        context "appointment belongs to the logged in user" do
          it "deletes a valid appointment" do
            expect {
              delete appointment_url @appointment1
            }.to change(Appointment, :count).by(-1)
          end

          it "sends email to the user" do
            expect {
              delete appointment_url @appointment1
            }.to have_enqueued_mail(AppointmentMailer, :cancelled)
          end
        end

        context "appointment belongs to another user" do
          it "renders 404 page" do
            user2 = create(:user, email: "another@user.com")
            appointment2 = create(:appointment, user_id: user2.id)
            delete appointment_url appointment2
            expect(response.status).to eq(404)
          end
        end
      end

      context "invalid params" do
        it "does not delete appointment scheduled for less than 30 minutes" do
          Timecop.freeze(@appointment1.date_time - (Appointment::CANCEL_DEADLINE - 1.minute))
          expect {
            delete appointment_url @appointment1
          }.to change(Appointment, :count).by(0)
        end

        it "does not send cancellation mail" do
          Timecop.freeze(@appointment1.date_time - (Appointment::CANCEL_DEADLINE - 1.minute))
          expect {
            delete appointment_url @appointment1
          }.not_to have_enqueued_mail(Appointment)
        end
      end
    end

    context "user not logged in" do
      it "redirects to login page" do
        expect(
          delete appointment_path @appointment1
        ).to redirect_to(login_path)
      end
    end
  end

  describe "SHOW /show" do
    context "user logged in" do
      before do
        @appointment1 = create(:appointment, user_id: user1.id)
        post users_path, params: {
          user: user1.as_json
        }
      end

      context "appointment belongs to the logged in user" do
        it "prints the receipt in csv" do
          get appointment_path @appointment1, format: :csv
          expect (response.header["Content-Disposition"]).match("receipt-#{@appointment1.id}.csv")
        end

        it "prints the receipt in txt" do
          get appointment_path @appointment1, format: :txt
          expect (response.header["Content-Disposition"]).match("receipt-#{@appointment1.id}.txt")
        end

        it "prints the receipt in pdf" do
          get appointment_path @appointment1, format: :pdf
          expect (response.header["Content-Disposition"]).match("receipt-#{@appointment1.id}.pdf")
        end
      end

      context "appointment belongs to another user" do
        it "renders 404 page" do
          user2 = create(:user, email: "another@user.com")
          appointment2 = create(:appointment, user_id: user2.id)
          get appointment_path appointment2, format: :csv
          expect(response.status).to eq(404)
        end
      end

    end

    context "user not logged in" do
      it "redirects to login page" do
        expect(
          get appointment_path appointment1, format: :csv
        ).to redirect_to(login_path)
        expect(
          get appointment_path appointment1, format: :txt
        ).to redirect_to(login_path)
        expect(
          get appointment_path appointment1, format: :pdf
        ).to redirect_to(login_path)
      end
    end
  end
end
