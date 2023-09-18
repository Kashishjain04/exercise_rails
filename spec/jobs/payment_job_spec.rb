require 'rails_helper'

RSpec.describe PaymentJob, type: :job do
  it "should broadcast using turbo stream" do
    appointment = create(:appointment)
    expect(Turbo::StreamsChannel).to receive(:broadcast_render_later_to)
                                       .with(:appointment,
                                             partial: 'appointments/payment_success',
                                             locals: { appointment: }
                                       )
    PaymentJob.perform_now(appointment)
  end
end
