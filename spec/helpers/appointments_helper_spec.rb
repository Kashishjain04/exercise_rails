require 'rails_helper'

RSpec.describe AppointmentsHelper, type: :helper do
  it "converts appointment price to desired currency" do
    conversion_rates = FixerApi.today_rates
    expect(convert_appointment_price(conversion_rates, 'USD')).to eq(6.02)
  end

  it "prints appointment price in desired currency" do
    conversion_rates = FixerApi.today_rates
    expect(print_appointment_price(conversion_rates, 'USD')).to eq("6.02 USD")
  end

  it "should parse date_time for payment_success page" do
    date_time = DateTime.parse("01/01/2030, 11:00:00")
    expect(parse_time(date_time)).to eq("Tuesday, 1st January, 11:00 AM")
  end
end
