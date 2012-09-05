# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Create gaming platforms'
CoolGames::GamingPlatform.create!(name: 'Gocool', url: 'http://localhost:5000')

puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :email => 'user@example.com', :username => 'user', :password => 'please', :password_confirmation => 'please', :confirmed_at => Time.now.utc
puts 'New user created: ' << user.username
user2 = User.create! :email => 'user2@example.com', :username => 'user2', :password => 'please', :password_confirmation => 'please', :confirmed_at => Time.now.utc
puts 'New user created: ' << user2.username
