# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

200.times do |number|
  phone = (number+rand(2)).even?
  if phone
    Person.create(:first_name => "John", :last_name => "Doe ##{number}", :email => "john.doe#{number}@gmail.com", :address => "#{number} John Doe Street", :phonenumber => '123-123-1234')
  else
    Person.create(:first_name => "John", :last_name => "Doe ##{number}", :email => "john.doe#{number}@gmail.com", :address => "#{number} John Doe Street")
  end
end
