class Doctor < ApplicationRecord
  validates_presence_of :name, :address, :image
  has_many :appointments
  before_destroy :ensure_not_appointed

  # Time.zone = "Kolkata"
  START_TIME = Time.parse('11:00:00')
  END_TIME = Time.parse('16:00:00')
  BREAK_START_TIME = Time.parse('12:00:00')
  BREAK_END_TIME = Time.parse('14:00:00')

  MAX_DAYS = 7

  def available_slots
    booked_slots = appointments.all.map(&:date_time)
    slots = {}

    MAX_DAYS.times.each do |i|
      current_date = Date.today.in_time_zone("Kolkata") + i.days
      temp_slots = []

      start_time = get_time_on_day(current_date, START_TIME)
      break_start = get_time_on_day(current_date, BREAK_START_TIME)
      break_end = get_time_on_day(current_date, BREAK_END_TIME)
      end_time = get_time_on_day(current_date, END_TIME)

      time = start_time

      while time < break_start
        if time > DateTime.now && !booked_slots.include?(time)
          temp_slots.push(time)
        end
        time += 1.hours
      end

      time = break_end

      while time < end_time
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

end
