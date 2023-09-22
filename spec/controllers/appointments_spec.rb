require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  it do
    params = { appointment: {
      doctor_id: doctor.id,
      date_time: doctor.available_slots.first.first,
      user: user.as_json }
    }

    should permit(:doctor_id, :date_time, user: [:name, :email, :preferred_currency]).
      for(:create, params: params).
      on(:appointment)
  end
end