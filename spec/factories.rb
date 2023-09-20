FactoryBot.define do
  factory :doctor do
    name { "DoctorOne" }
    address { "Somewhere Doctor Address" }
    image { "doctors/doctor-1.png" }
  end

  factory :user do
    name { "UserOne" }
    email { "user@email.com" }
    preferred_currency { 'INR' }
  end

  factory :appointment do
    user { create(:user) }
    doctor { create(:doctor) }
    date_time { self.doctor.available_slots.values.first[0] }
    amount { 6.02 }
    currency { 'USD' }
  end
end