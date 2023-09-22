require 'rails_helper'

RSpec.describe AppointmentsHelper, type: :helper do
  it "prints appointment price in desired currency" do
    conversion_rates = FixerApi.today_rates
    expect(print_appointment_price(
             conversion_rates,
             'USD'
           )).to eq("6.02 USD")
  end

  it "prints appointment fees in user's preferred currency" do
    expect(parse_appointment_fees(appointment)).to eq("USD 6.02")
  end

  it "prints date_time for payment_success page" do
    date_time = DateTime.parse("01/01/2030, 11:00:00")
    expect(parse_appointment_time(date_time, 1)).to eq("Tuesday, 1st January, 11:00 AM")
  end

  it "prints date for payment details card" do
    date_time = DateTime.parse("01/01/2030, 11:00:00")
    expect(parse_appointment_time(date_time, 2)).to eq("Tuesday, 1st January")
  end

  it "prints time for payment details card" do
    date_time = DateTime.parse("01/01/2030, 11:00:00")
    expect(parse_appointment_time(date_time, 3)).to eq("11:00 AM")
  end

  it "prints date_time for appointment receipt" do
    date_time = DateTime.parse("01/01/2030, 11:00:00")
    expect(parse_appointment_time(date_time, 4)).to eq("1st January, 11:00 AM")
  end
end
