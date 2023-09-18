json.extract! appointment, :id, :doctor_id, :user_id, :date_time, :currency_rates, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
