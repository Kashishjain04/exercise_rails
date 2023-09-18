class AppointmentMailer < ApplicationMailer
  helper :appointments

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.appointment_mailer.booked.subject
  #
  def booked(appointment)
    @appointment = appointment
    mail to: appointment.user.email, subject: 'Medi App Appointment Booked'
  end

  def completed(appointment)
    @appointment = appointment
    mail to: appointment.user.email, subject: 'Medi App Consultation Complete'
  end

  def cancelled(appointment)
    @appointment = appointment
    mail to: appointment.user.email, subject: 'Medi App Appointment Cancelled'
  end
end
