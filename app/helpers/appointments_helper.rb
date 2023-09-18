module AppointmentsHelper
  def convert_appointment_price(rates, currency)
    price = Appointment::APPOINTMENT_PRICE_INR
    (price * rates[currency]).round(2)
  end

  def print_appointment_price(rates, currency)
    actual_price = convert_appointment_price(rates, currency)
    "#{actual_price} #{currency}"
  end

  def parse_time(date_time)
    day_string = if date_time.today?
                   "Today"
                 elsif date_time.tomorrow?
                   "Tomorrow"
                 else
                   date_time.strftime("%A")
                 end
    date_string = date_time.day.ordinalize

    "#{day_string}, #{date_string} #{date_time.strftime("%B, %l:%M %p")}"
  end
end
