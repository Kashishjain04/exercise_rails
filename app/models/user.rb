class User < ApplicationRecord
  CURRENCIES = %w[INR USD EUR]

  has_many :appointments, dependent: :destroy
  validates_presence_of :name, :email, :preferred_currency
  validates_uniqueness_of :email
  validates :preferred_currency, inclusion: CURRENCIES
end
