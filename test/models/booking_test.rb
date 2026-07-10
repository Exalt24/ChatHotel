require "test_helper"

class BookingTest < ActiveSupport::TestCase
  def setup
    @booking = Booking.new(
      user: users(:one),
      hotel: hotels(:one),
      start_date: Date.today + 10,
      end_date: Date.today + 12,
      room_type: "single_room",
      status: "confirmed",
      booked_name: "Alice Reyes",
      booked_number: "09171234567"
    )
  end

  test "valid booking is valid" do
    assert @booking.valid?
  end

  test "start and end dates are required" do
    @booking.start_date = nil
    assert_not @booking.valid?
  end

  test "start date cannot be in the past" do
    @booking.start_date = Date.today - 1
    assert_not @booking.valid?
  end

  test "end date must be on or after start date" do
    @booking.end_date = @booking.start_date - 1
    assert_not @booking.valid?
  end

  test "booked name and number are required" do
    @booking.booked_name = ""
    assert_not @booking.valid?
  end

  test "total cost is computed before validation" do
    @booking.valid?
    assert @booking.total_cost.to_i.positive?
  end
end
