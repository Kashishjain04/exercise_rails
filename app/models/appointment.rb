require 'payment_gateway'

class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :user
  validates_presence_of :date_time, :amount, :currency, on: :create
  validate :future_date_time, on: :create
  validate :date_time_is_valid_slot, on: :create
  validates :amount, numericality: { greater_than_or_equal_to: 0.01 }, on: :create
  validates :currency, inclusion: User::CURRENCIES

  APPOINTMENT_PRICE_INR = 500



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
end
