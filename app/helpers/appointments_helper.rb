module AppointmentsHelper
  def convert_currency(amount, rates, currency)
    (amount * rates[currency]).round(2)
  end

  def print_appointment_price(amount, rates, currency)
    actual_price = convert_currency(amount, rates, currency)
    "#{actual_price} #{currency}"
  end

  def parse_time(date_time, format)
    day_string = if date_time.today?
                   t('appointments.helpers.today')
                 elsif date_time.tomorrow?
                   t('appointments.helpers.tomorrow')
                 else
                   date_time.strftime("%A")
                 end
    date_string = date_time.day.ordinalize

    case format
    when 1
      "#{day_string}, #{date_string} #{date_time.strftime("%B, %l:%M %p")}"
    when 2
      "#{day_string}, #{date_string} #{date_time.strftime("%B")}"
    when 3
      date_time.strftime("%l:%M %p")
    end
  end
end
