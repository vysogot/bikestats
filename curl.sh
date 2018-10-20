curl -d '{"start_address":"Slowackiego 3, Otwock, Polska", "destination_address":"Plac Europejski 2, Warszawa, Polska", "price":"99.99", "date":"2018-10-16"}' -H "Content-Type: application/json" -X POST http://localhost:9292/api/trips
echo -e
sleep .2

curl -d '{"start_address":"Muzeum Narodowe, Warszawa, Polska", "destination_address":"Plac Europejski 2, Warszawa, Polska", "price":"200", "date":"2018-10-15"}' -H "Content-Type: application/json" -X POST http://localhost:9292/api/trips
echo -e
sleep .2

curl -d '{"start_address":"Teatr Nowy, Poznań, Polska", "destination_address":"Plac Europejski 2, Warszawa, Polska", "price":"10.00", "date":"2018-10-18"}' -H "Content-Type: application/json" -X POST http://localhost:9292/api/trips
echo -e
sleep .2

echo -e "\nWeekly stats:\n"
curl http://localhost:9292/api/stats/weekly
echo -e
sleep .2

echo -e "\nMonthly stats:\n"
curl http://localhost:9292/api/stats/monthly
echo -e
