# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file .env file.
require 'factory_bot_rails'

user = FactoryBot.create(:user, :fort_collins, email: 'user@example.com')
user2 = FactoryBot.create(:user, :boulder, email: 'user2@example.com')
user3 = FactoryBot.create(:user, :grand_junction, email: 'user3@example.com')
# unconfirmed user
FactoryBot.create(:user, email: 'unconfirmed@example.com', confirmed_at: nil)

[7031010, 850844, 368627, 7001490, 46286, 7019010, 68428,
 7025613, 1362740, 520343, 7002791, 255931, 601365, 53819,
 5896987, 52119, 43824, 6485776, 7025541, 7001533, 7010645,
 6354904, 967181, 7031312, 7031740, 5856031, 7021022, 6576183,
 2214487, 632917].each.with_index do |trail_id, index| 
   if index % 3 == 0 
     FactoryBot.create(:ride, trail_id: trail_id, user: user2)
   else
     FactoryBot.create(:ride, trail_id: trail_id, user: user)
   end
 end

 user2.rides.each do |ride|
   FactoryBot.create(:participation, :accepted, user: user, ride: ride)
 end

 30.times do |i|
   if i % 3 == 0 
     u = user3
   elsif i % 2 == 0 
     u = user2
   else
     u = user
   end
   FactoryBot.create(:comment, ride: user.rides.first, user: u)
 end

# email preview setup
email_ride = FactoryBot.create(:ride, user: user3)
FactoryBot.create(:comment, user: user, ride: email_ride)
FactoryBot.create(:comment, user: user2, ride: email_ride)
# ParticipationCreatedJob
FactoryBot.create(:participation, :pending, user: user, ride: email_ride)
# ParticipationAcceptedJob
participation = FactoryBot.create(:participation, :pending, user: user3, ride: user.rides.first)
participation.accepted!
