class UserPreferredCurrencyToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :preferred_currency, :string, default: 'INR'
  end
end
