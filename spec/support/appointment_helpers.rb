module AppointmentHelpers
  include Rails.application.routes.url_helpers
  def create_appointment
    post appointments_url, params: {
      appointment: {
        doctor_id: doctor.id,
        date_time: doctor.available_slots.values.first.first,
        user: user.as_json,
      }
    }, as: :turbo_stream
  end
end