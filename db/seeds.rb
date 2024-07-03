require 'faker'
include PricingHelper

# Clear existing data
Booking.destroy_all
Hotel.destroy_all
User.destroy_all

# Create main customer user (if needed)
admin_user = User.new(
  first_name: "Admin",
  last_name: "Admin",
  email: "admin@gmail.com",
  mobile_number: Faker::Base.regexify(/^(08|09)\d{9}$/),
  password: "daxdax12345",
  password_confirmation: "daxdax12345",
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

if admin_user.save
  puts "Admin user created successfully!"
else
  puts "Error creating admin user: #{admin_user.errors.full_messages.join(", ")}"
end

User.create!(
  first_name: "Daniel",
  last_name: "Cruz",
  email: "danielalexispadolina@gmail.com",
  mobile_number: Faker::Base.regexify(/^(08|09)\d{9}$/),
  password: "daxdax12345",
  password_confirmation: "daxdax12345",
  activated: true,
  activated_at: Time.zone.now
)

# Create additional customer users
5.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    mobile_number: Faker::Base.regexify(/^(08|09)\d{9}$/),
    password: 'password',
    password_confirmation: 'password',
    activated: true,
    activated_at: Time.zone.now
  )
end

# Create hotels
amenities_list = [
  "Pool", "Gym", "Spa", "Restaurant", "WiFi", "Parking", "Pet-friendly"
]

10.times do
  Hotel.create!(
    name: Faker::Company.name,
    description: Faker::Lorem.paragraph(sentence_count: 5),
    location: Faker::Address.full_address,
    contact_details: Faker::Base.regexify(/^(08|09)\d{9}$/),
    amenities: amenities_list.sample(rand(1..amenities_list.length)).join(', '), # Randomly select amenities from the list
    single_room_price: rand(50..200),
    double_room_price: rand(300..400),
    suite_price: rand(500..800)
  )
end


# Create bookings for customers
User.where(admin: false).each do |customer|
  rand(1..2).times do
    hotel = Hotel.all.sample
    room_type = %w[single_room double_room suite].sample
    start_date = Faker::Date.between(from: Date.today, to: 1.year.from_now)
    end_date = Faker::Date.between(from: start_date, to: start_date + 10.days)
    status = %w[confirmed cancelled].sample

    # Check for overlapping dates for the same room type in the same hotel
    if Booking.where(hotel_id: hotel.id, room_type: room_type)
      .where("start_date <= ? AND end_date >= ?", end_date, start_date)
      .exists?
    puts "Skipping booking due to overlapping room availability"
    next  # Skip to the next iteration
    end

    Booking.create!(
      user: customer,
      hotel: hotel,
      start_date: start_date,
      end_date: end_date,
      room_type: room_type,
      status: status,
      booked_name: "#{customer.first_name} #{customer.last_name}",
      booked_number: customer.mobile_number
    )
  end
end

puts "Seed data created successfully!"
