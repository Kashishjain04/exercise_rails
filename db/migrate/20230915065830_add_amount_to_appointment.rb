class AddAmountToAppointment < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :amount, :numeric, null: false
    add_column :appointments, :currency, :text, null: false
    remove_column :appointments, :currency_rates
  end
end
