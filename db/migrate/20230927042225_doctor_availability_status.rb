class DoctorAvailabilityStatus < ActiveRecord::Migration[7.0]
  def change
    add_column :doctors, :available, :boolean, default: true
  end
end
