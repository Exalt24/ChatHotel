require "test_helper"

class HotelTest < ActiveSupport::TestCase
  def setup
    @hotel = Hotel.new(
      name: "Grand Plaza Hotel",
      description: "A comfortable stay in the heart of the city.",
      location: "Manila",
      contact_details: "09171234567",
      amenities: "WiFi, Pool",
      single_room_price: 1000,
      double_room_price: 2000,
      suite_price: 3000
    )
  end

  test "valid hotel is valid" do
    assert @hotel.valid?
  end

  test "name and description are required" do
    @hotel.name = ""
    assert_not @hotel.valid?
    @hotel.name = "Grand Plaza Hotel"
    @hotel.description = ""
    assert_not @hotel.valid?
  end

  test "contact details must be a valid PH mobile number" do
    @hotel.contact_details = "123"
    assert_not @hotel.valid?
  end

  test "room prices must increase from single to double to suite" do
    @hotel.single_room_price = 2000
    @hotel.double_room_price = 1000
    assert_not @hotel.valid?
  end

  test "room prices must be positive" do
    @hotel.single_room_price = 0
    assert_not @hotel.valid?
  end
end
