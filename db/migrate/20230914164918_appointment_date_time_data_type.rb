class AppointmentDateTimeDataType < ActiveRecord::Migration[7.0]
  def change
    remove_column :appointments, :date_time
    add_column :appointments, :date_time, :datetime
  end
end
