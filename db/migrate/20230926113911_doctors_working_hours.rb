class DoctorsWorkingHours < ActiveRecord::Migration[7.0]
  def change
    change_column :doctors, :start_time, :time, default: DateTime.parse('10:00:00+0530')
    change_column :doctors, :end_time, :time, default: DateTime.parse('16:00:00+0530')
    change_column :doctors, :break_start_time, :time, default: DateTime.parse('13:00:00+0530')
    change_column :doctors, :break_end_time, :time, default: DateTime.parse('14:00:00+0530')
  end
end
