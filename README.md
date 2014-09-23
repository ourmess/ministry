# ourmess: ministry

server component of trash locator app

* ruby 2.1.3p242
* rails 4.1.5
* mongoid 4.0.0
* nodejs 0.10.24

#Contribution.create({:user_id => "USER_ID", :category_name => "category_name", :full_res_url => "full", :low_res_url => "low", :keywords => ['trash'], :location => [34.052234,-118.243685]})
#Contribution.geo_near([34.052234,-118.243685])


cd /home/ubuntu/app && git clone https://github.com/advectus/ministry.git
cd /home/ubuntu/app/ministry && npm install bower
cd /home/ubuntu/app/ministry && bundle install
cd /home/ubuntu/app/ministry && rake bower:install
cd /home/ubuntu/app/ministry && rake db:drop
cd /home/ubuntu/app/ministry && rake db:mongoid:create_indexes