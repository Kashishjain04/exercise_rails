require 'rails_helper'

RSpec.describe PaymentJob, type: :job do
  let(:custom_uid) { SecureRandom.uuid }
  subject { PaymentJob.perform_now(appointment, custom_uid) }

  before do
    allow(PaymentGateway).to receive(:make_payment)
  end

  it "broadcasts using turbo stream" do
    expect(Turbo::StreamsChannel).to receive(:broadcast_render_later_to)
                                       .with("appointment-#{custom_uid}",
                                             partial: 'appointments/processing_payment'
                                       )

    expect(Turbo::StreamsChannel).to receive(:broadcast_render_later_to)
                                       .with("appointment-#{custom_uid}",
                                             partial: 'appointments/payment_success',
                                             locals: { appointment: }
                                       )

    subject
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
