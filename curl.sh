echo -e "\nBikeramp!\n"
sleep .8
echo -e "Let's start the demo...\n"
sleep .5

curl -X POST "http://localhost:9292/api/trips?start_address=Slowackiego%203,%20Otwock,%20Polska&destination_address=Plac%20Europejski%202,%20Warszawa,%20Polska&price=99.99&date=2018-10-16" -d ''
echo -e
sleep .2

curl -X POST "http://localhost:9292/api/trips?start_address=Muzeum%20Narodowe,%20Warszawa,%20Polska&destination_address=Plac%20Europejski%202,%20Warszawa,%20Polska&price=200&date=2018-10-15" -d ''
echo -e
sleep .2

curl -X POST "http://localhost:9292/api/trips?start_address=Teatr%20Nowy,%20Poznan,%20Polska&destination_address=Plac%20Europejski%202,%20Warszawa,%20Polska&price=10.00&date=2018-10-22" -d ''
echo -e
sleep .2

echo -e "\nBackgroud jobs fetching distances..."
sleep 1

echo -e "\nWeekly stats:\n"
curl http://localhost:9292/api/stats/weekly
echo -e
sleep .2

echo -e "\nMonthly stats:\n"
curl http://localhost:9292/api/stats/monthly
echo -e "\n\nThanks!\n"
