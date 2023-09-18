json.extract! user, :id, :name, :email, :preferred_currency, :created_at, :updated_at
json.url user_url(user, format: :json)
