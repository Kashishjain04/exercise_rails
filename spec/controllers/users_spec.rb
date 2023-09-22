require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it do
    params = { user: {
      name: user.name,
      email: user.email,
      preferred_currency: user.preferred_currency
    } }

    should permit(:name, :email, :preferred_currency).
      for(:create, params: params).
      on(:user)
  end
end