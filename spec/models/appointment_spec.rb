require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:invalid_doctor) { create(:doctor, available: false) }
  let(:invalid_date_times) { [
    DateTime.now - 1.hours,
    doctor.available_slots.values.first[0] + 10.minutes
  ] }

  describe 'associations' do
    it { should belong_to(:user).class_name('User') }
    it { should belong_to(:doctor).class_name('Doctor') }
  end

  describe "validations" do
    subject { appointment }
    context "presence" do
      [:date_time, :amount_inr, :currency_rates].each do |field|
        it { should validate_presence_of(field) }
      end
    end
    it { should validate_numericality_of(:amount_inr).is_greater_than_or_equal_to(0.01) }
    it { should_not allow_values(*invalid_date_times).for(:date_time) }
    it { should_not allow_value(FixerApi.today_rates.except("USD")).for(:currency_rates) }
    it { should_not allow_value(invalid_doctor).for(:doctor) }
  end
end
