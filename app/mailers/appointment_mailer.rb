class AppointmentMailer < ApplicationMailer
  helper :appointments

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.appointment_mailer.booked.subject
  #
  def booked(appointment)
    @appointment = appointment
    mail to: appointment.user.email
  end

  def receipt(appointment)
    @appointment = appointment
    mail to: appointment.user.email
  end

  def cancelled(appointment)
    @appointment = Appointment.new(**appointment)
    mail to: @appointment.user.email
  end
end
