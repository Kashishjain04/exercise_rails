class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :user

  validates_presence_of :date_time, :amount_inr, :currency_rates
  validates :amount_inr, numericality: { greater_than_or_equal_to: 0.01 }
  validate :future_date_time
  validate :date_time_is_valid_slot
  validate :currency_rates_format
  validate :doctor_to_be_available

  after_destroy :send_cancelled_mail

  APPOINTMENT_PRICE_INR = 500
  CANCEL_DEADLINE = 30.minutes
  COMPLETION_MAIL_DELIVERY = 2.hours

  private
  def future_date_time
    errors.add(:date_time,
               "must be in future") unless date_time&.after?(DateTime.now)
  end

  def date_time_is_valid_slot
    if date_time.present? && doctor.present?
      date = date_time.to_datetime.beginning_of_day
      slots = doctor.available_slots[date]

      errors.add(:date_time,
                 "must be a valid slot") unless !slots.nil? && date_time.in?(slots)
    end
  end

  def date_time_more_than_half_hour
    deadline = DateTime.now - CANCEL_DEADLINE

    errors.add(:date_time,
               "cancellation window closed") unless date_time&.before?(deadline)
  end

  def currency_rates_format
    if currency_rates.present?
      User::CURRENCIES.each do |currency|
        errors.add(:currency_rates,
                   "conversion for #{currency} is not present") if currency_rates[currency].nil?
      end
    end
  end

  def doctor_to_be_available
    if doctor.present?
      errors.add(:doctor, "not Available") unless doctor.available
    end
  end

  def send_cancelled_mail
    AppointmentMailer.cancelled(self.as_json).deliver_later
  end
end
