# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
  config.action_mailer.delivery_method = :smtp
  host = ENV['HOST'] || 'http://localhost:3000'
  config.action_mailer.default_url_options = { host: host }

  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    name: 'Kashish Jain',
    authentication: "plain",
    user_name: "jainabhishek7204@gmail.com",
    password: ENV['SMTP_PASSWORD'],
    enable_starttls_auto: true
  }

  config.i18n.fallbacks = true
end