class PaymentJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    Turbo::StreamsChannel.broadcast_render_to(
      :appointment,
      partial: 'appointments/processing_payment')

    PaymentGateway.make_payment

    AppointmentMailer.booked(appointment).deliver_later
    AppointmentMailer.completed(appointment)
      .deliver_later(wait_until: appointment.date_time + Appointment::COMPLETION_MAIL_DELIVERY)
    Turbo::StreamsChannel.broadcast_render_later_to(
      :appointment,
      partial: 'appointments/payment_success',
      locals: { appointment: })
  end
end
