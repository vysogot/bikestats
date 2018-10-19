FactoryBot.define do
  factory :trip do
    start_address { 'Poniatowskiego 2a, Otwock, Polska' }
    destination_address  { 'Plac Europejski 2, Warszawa, Polska'  }
    price  { 10 }
    date { Time.now.strftime("%Y-%m-%d") }
    distance { 5 }
  end
end
