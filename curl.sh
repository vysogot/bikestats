echo -e "\nBikeramp!\n"
sleep .8
echo -e "Let's start the demo...\n"
sleep .5

curl -d '{"start_address":"Slowackiego 3, Otwock, Polska", "destination_address":"Plac Europejski 2, Warszawa, Polska", "price":"99.99", "date":"2018-11-05"}' -H "Content-Type: application/json" -X POST http://localhost:9292/api/trips
echo -e
sleep .2

curl -X POST "http://localhost:9292/api/trips?start_address=Muzeum%20Narodowe,%20Warszawa,%20Polska&destination_address=Plac%20Europejski%202,%20Warszawa,%20Polska&price=200&date=2018-11-13" -d ''
echo -e
sleep .2

curl -X POST "http://localhost:9292/api/trips?start_address=Teatr%20Nowy,%20Poznan,%20Polska&destination_address=Plac%20Europejski%202,%20Warszawa,%20Polska&price=10.00&date=2018-11-11" -d ''
echo -e
sleep .2

echo -e "\nBackgroud jobs fetching distances..."
sleep 1

echo -e "\nWeekly stats:\n"
curl -s http://localhost:9292/api/stats/weekly | json_pp
echo -e
sleep .2

echo -e "\nMonthly stats:\n"
curl -s http://localhost:9292/api/stats/monthly | json_pp
echo -e "\n\nThanks!\n"
