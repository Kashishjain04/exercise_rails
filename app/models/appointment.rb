require 'payment_gateway'

class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :user
  validates_presence_of :date_time, :amount_inr, :currency_rates, on: :create
  validate :future_date_time, on: :create
  validate :date_time_is_valid_slot, on: :create
  validates :amount_inr, numericality: { greater_than_or_equal_to: 0.01 }, on: :create
  validate :currency_rates_format, on: :create
  after_destroy :send_cancelled_mail

  APPOINTMENT_PRICE_INR = 500
  CANCEL_DEADLINE = 30.minutes
  COMPLETION_MAIL_DELIVERY = 2.hours

  private

  def future_date_time
    if date_time.present? && date_time < DateTime.now
      errors.add(:date_time, "must be in future")
      throw :abort
    end
  end

  def date_time_is_valid_slot
    if date_time.present? && doctor.present?
      date = Date.parse(date_time.to_s).in_time_zone("Kolkata")
      slots = doctor.available_slots[date]
      unless date_time.in? slots
        errors.add(:date_time, "must be a valid slot")
        throw :abort
      end
    end
  end

  def date_time_more_than_half_hour
    if date_time.present? && (date_time - DateTime.now) <= CANCEL_DEADLINE
      errors.add(:date_time, "cancellation window closed")
      throw :abort
    end
  end

  def currency_rates_format
    if currency_rates.present?
      User::CURRENCIES.each do |currency|
        if currency_rates[currency].nil?
          errors.add(:currency_rates, "conversion for #{currency} is not present")
          throw :abort
        end
      end
    end
  end

  def send_cancelled_mail
    AppointmentMailer.cancelled(self.as_json).deliver_later
  end
end
