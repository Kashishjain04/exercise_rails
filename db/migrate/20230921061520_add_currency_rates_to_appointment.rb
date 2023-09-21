class AddCurrencyRatesToAppointment < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :currency_rates, :json, null: false
    rename_column :appointments, :amount, :amount_inr
    remove_column :appointments, :currency
  end
end
