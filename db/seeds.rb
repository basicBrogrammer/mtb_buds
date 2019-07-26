# frozen_string_literal: true

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

[7_031_010, 850_844, 368_627, 7_001_490, 46_286, 7_019_010, 68_428,
 7_025_613, 1_362_740, 520_343, 7_002_791, 255_931, 601_365, 53_819,
 5_896_987, 52_119, 43_824, 6_485_776, 7_025_541, 7_001_533, 7_010_645,
 6_354_904, 967_181, 7_031_312, 7_031_740, 5_856_031, 7_021_022, 6_576_183,
 2_214_487, 632_917].each.with_index do |trail_id, index|
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
  u = if i % 3 == 0
        user3
      elsif i.even?
        user2
      else
        user
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
