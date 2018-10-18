FactoryBot.define do
  factory :trip do
    start_address { 'Otwock' }
    destination_address  { 'Plac Europejski 2, Warszawa, Polska'  }
    price  { 10 }
    date { Time.now }
    distance { 5 }
  end
end
