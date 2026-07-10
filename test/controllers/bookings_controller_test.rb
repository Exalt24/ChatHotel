require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  test "index redirects to login when not authenticated" do
    get bookings_url
    assert_redirected_to login_url
  end

  test "show redirects to login when not authenticated" do
    get booking_url(bookings(:one))
    assert_redirected_to login_url
  end
end
