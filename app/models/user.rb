class User < ApplicationRecord
  CURRENCIES = %w[INR USD EUR]

  has_many :appointments, dependent: :destroy
  validates :name, presence: true, format: /\A[A-Za-z][\w ]{5,}/
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  validates :preferred_currency, presence: true, inclusion: CURRENCIES
end
