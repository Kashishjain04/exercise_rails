class User < ApplicationRecord
  CURRENCIES = %w[INR USD EUR]

  has_many :appointments, dependent: :destroy
  validates :name, presence: true, format: /\A[A-Za-z][\w ]{5,}/
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  validates :preferred_currency, presence: true, inclusion: CURRENCIES

  def self.login_or_signup(user_params)
    existing_user = User.find_by(email: user_params[:email])

    if existing_user
      if existing_user.name.downcase == user_params[:name].downcase
        user = existing_user
        user.update(preferred_currency: user_params[:preferred_currency])
      else
        user = User.new(user_params)
        user.errors.add(:base, "Name and email don't match our records")
      end
    else
      user = User.new(user_params)
    end

    user
  end
end
