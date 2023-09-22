FactoryBot.define do
  factory :doctor do
    name { "DoctorOne" }
    address { "Somewhere Doctor Address" }
    image { "doctors/doctor-1.png" }
  end

  factory :user do
    name { "UserOne" }
    email { "user@email.com" }
    preferred_currency { 'USD' }
  end

  factory :appointment do
    user { create(:user) }
    doctor { create(:doctor) }
    date_time { self.doctor.available_slots.values.first.first }
    amount_inr { 500 }
    currency_rates { { INR: 88.686078,
                       USD: 0.01203509078,
                       EUR: 0.01127572695
    } }
  end
end