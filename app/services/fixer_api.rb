require 'uri'
require 'net/http'

module FixerApi

  def self.today_rates
    Rails.cache.fetch([self, :currency_rates], expires_in: 1.day) do
      rates = JSON.parse(currency_rates.body)["rates"]
      rates = rates.map { |key, val| [key, val.to_f / rates["INR"]] }.to_h
      rates.as_json
    end
  end

  def self.currency_rates
    uri = URI("http://data.fixer.io/api/latest")
    symbols = User::CURRENCIES.join(',')
    params = {
      # access_key: ENV['FIXER_API_KEY'],
      access_key: '35a3ad0f2f253d37131b68cd1b5953fc',
      symbols:
    }
    uri.query = URI.encode_www_form(params)
    puts "----------"
    puts "Fetching Currency Rates..."
    puts "----------"
    res = Net::HTTP.get_response(uri)
    res.is_a?(Net::HTTPSuccess) ? res : { body: {} }
  end
end