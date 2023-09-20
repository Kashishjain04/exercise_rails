class Doctor < ApplicationRecord
  validates_presence_of :name, :address, :image
  validates :name, presence: true, format: /\A[A-Za-z][\w ]{5,}\z/
  validates :address, presence: true, format: /\A.{6,}/
  validates :image, presence: true, format: /\A.+\.(gif|png|jpg|jpeg)\z/
  has_many :appointments
  before_destroy :ensure_not_appointed
  validate :working_timestamps

  MAX_DAYS = 7

  def available_slots
    booked_slots = appointments.all.map(&:date_time)
    slots = {}

    MAX_DAYS.times.each do |i|
      current_date = Date.today.in_time_zone("Kolkata") + i.days
      temp_slots = []

      start_timestamp = get_time_on_day(current_date, start_time)
      break_start_timestamp = get_time_on_day(current_date, break_start_time)
      break_end_timestamp = get_time_on_day(current_date, break_end_time)
      end_timestamp = get_time_on_day(current_date, end_time)

      time = start_timestamp

      while time < break_start_timestamp
        if time > DateTime.now && !booked_slots.include?(time)
          temp_slots.push(time)
        end
        time += 1.hours
      end

      time = break_end_timestamp

      while time < end_timestamp
        if time > DateTime.now && !booked_slots.include?(time)
          temp_slots.push(time)
        end
        time += 1.hours
      end

      slots[current_date] = temp_slots unless temp_slots.empty?
    end
    slots
  end

  def next_available_today
    today = Date.today.in_time_zone("Kolkata")
    today_slots = available_slots[today]

    return nil if today_slots.nil? || today_slots.empty?
    today_slots[0].strftime("%l:%M %p")
  end

  private
  def get_time_on_day(date, time)
    date.to_datetime + time.seconds_since_midnight.seconds
  end

  def ensure_not_appointed
    unless appointments.empty?
      errors.add(:base, "Appointment bookings present")
      throw :abort
    end
  end

  def working_timestamps
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
