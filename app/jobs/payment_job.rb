require 'payment_gateway'

class PaymentJob < ApplicationJob
  queue_as :default

  def perform(appointment, uid)
    Turbo::StreamsChannel.broadcast_render_later_to(
      "appointment-#{uid}",
      partial: 'appointments/processing_payment')

    PaymentGateway.make_payment

    AppointmentMailer.booked(appointment).deliver_later
    AppointmentMailer.receipt(appointment)
                     .deliver_later(wait_until: appointment.date_time + Appointment::COMPLETION_MAIL_DELIVERY)

    Turbo::StreamsChannel.broadcast_render_later_to(
      "appointment-#{uid}",
      partial: 'appointments/payment_success',
      locals: { appointment: })
  end
end
