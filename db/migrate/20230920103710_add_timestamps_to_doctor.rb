class AddTimestampsToDoctor < ActiveRecord::Migration[7.0]
  def change
    add_column :doctors, :start_time, :time, default: Time.parse('11:00:00')
    add_column :doctors, :end_time, :time, default: Time.parse('16:00:00')
    add_column :doctors, :break_start_time, :time, default: Time.parse('12:00:00')
    add_column :doctors, :break_end_time, :time, default: Time.parse('14:00:00')
  end
end
