# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do |i|
  Company.create!(name: Faker::Company.name)
end

100.times do |i|
  client = Customer.create!(
    email: Faker::Internet.email,
    name: Faker::Name.name,
    company_id: Faker::Number.between(1, 10))
  Address.create!(
    city: Faker::Address.city,
    street: Faker::Address.street_name,
    num: Faker::Address.building_number,
    customer_id: client.id)
end
