require "rails_helper"

RSpec.describe AppointmentMailer, type: :mailer do
  describe "booked" do
    let(:mail) { AppointmentMailer.booked(appointment1) }

    it "renders the headers" do
      expect(mail.subject).to eq("Medi App Appointment Booked")
      expect(mail.to).to eq(["user@email.com"])
      expect(mail.from).to eq(["jainabhishek7204@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("We would like to inform you that, your appointment is booked with us.")
    end
  end

  describe "cancelled" do
    let(:mail) { AppointmentMailer.cancelled(appointment1) }

    it "renders the headers" do
      expect(mail.subject).to eq("Medi App Appointment Cancelled")
      expect(mail.to).to eq(["user@email.com"])
      expect(mail.from).to eq(["jainabhishek7204@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Your appointment ##{appointment1.id} is cancelled.")
    end
  end

  describe "completed" do
    let(:mail) { AppointmentMailer.completed(appointment1) }

    it "renders the headers" do
      expect(mail.subject).to eq("Medi App Consultation Complete")
      expect(mail.to).to eq(["user@email.com"])
      expect(mail.from).to eq(["jainabhishek7204@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Thank you for choosing <strong>Medi App</strong> for your consultation.")
    end
  end

end
