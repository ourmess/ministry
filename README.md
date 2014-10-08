# ourmess: ministry

server component of trash locator app

* ruby 2.1.3p242
* rails 4.1.5
* mongoid 4.0.0
* nodejs 0.10.24

#Contribution.create({:participant_id => "USER_ID", :category_name => "category_name", :full_res_url => "full", :low_res_url => "low", :keywords => ['trash'], :location => [34.052234,-118.243685]})
#Contribution.geo_near([34.052234,-118.243685])
#curl -X POST http://54.166.205.176:3000/api/v1/contributions/create -d '{"participant_id":"1","category_name":"cat","full_res_url":"blah.jpg","lat":"34.052240","lon":"-118.243690"}' -H "Content-Type: application/json"


cd /home/ubuntu/app && git clone https://github.com/advectus/ministry.git
cd /home/ubuntu/app/ministry && npm install bower
cd /home/ubuntu/app/ministry && bundle install
cd /home/ubuntu/app/ministry && rake bower:install
cd /home/ubuntu/app/ministry && rake db:drop
cd /home/ubuntu/app/ministry && rake db:mongoid:create_indexes