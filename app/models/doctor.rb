class Doctor < ApplicationRecord
  DOCTOR_MAXIMUM_AVAILABILITY = 7
  SUNDAY = 7

  has_many :appointments

  validates_presence_of :name, :address, :image, :city
  validates :name, format: NAME_REGEXP
  validates :address, format: /\A.{6,}/
  validates :image, format: /\A.+\.(gif|png|jpg|jpeg)\z/
  validate :validate_working_timestamps

  before_destroy :ensure_not_appointed

  def available_slots
    slots = {}
    return slots unless available

    DOCTOR_MAXIMUM_AVAILABILITY.times.each do |i|
      date = DateTime.now.beginning_of_day + i.days

      next if date.cwday == SUNDAY

      start_timestamp = time_of_day(date, start_time)
      end_timestamp = time_of_day(date, end_time)

      all_available_slots = slots_between(start_timestamp, end_timestamp)
                              .select! { |slot| slot_available?(slot) }

      slots[date] = all_available_slots unless all_available_slots.empty?
    end
    slots
  end

  def next_available_today
    today = DateTime.now.beginning_of_day

    today_slots = available_slots[today]

    return nil if today_slots.nil?
    today_slots[0].strftime("%l:%M %p")
  end

  private
  def time_of_day(date, time)
    date + time.seconds_since_midnight.seconds
  end

  def booked_slots
    appointments.all.map(&:date_time)
  end

  def slot_available?(slot)
    date = slot.beginning_of_day

    break_start_timestamp = time_of_day(date, break_start_time)
    break_end_timestamp = time_of_day(date, break_end_time)

    slot.future? && !booked_slots.include?(slot) && !slot.between_exclusive?(break_start_timestamp, break_end_timestamp)
  end

  def slots_between(start_time, end_time)
    start_time.step(end_time, 1.0 / 24).to_a
  end

  def ensure_not_appointed
    unless appointments.empty?
      errors.add(:appointments, "Appointment bookings already present")
      throw :abort
    end
  end

  def validate_working_timestamps
    unless break_end_time < end_time
      errors.add(:break_end_time, "Doctor's working timestamps are invalid")
      throw :abort
    end
    unless break_start_time < break_end_time
      errors.add(:break_start_time, "Doctor's working timestamps are invalid")
      throw :abort
    end
    unless start_time < break_start_time
      errors.add(:start_time, "Doctor's working timestamps are invalid")
      throw :abort
    end
  end
end
