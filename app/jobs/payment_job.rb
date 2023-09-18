class PaymentJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    PaymentGateway.make_payment
    Turbo::StreamsChannel.broadcast_render_later_to(
      :appointment,
      partial: 'appointments/payment_success',
      locals: {appointment:})
  end
end
