require "test_helper"

class HotelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hotel = hotels(:one)
  end

  test "should get index" do
    get hotels_url
    assert_response :success
  end

  test "should show hotel" do
    get hotel_url(@hotel)
    assert_response :success
  end

  test "room_price returns the price for a room type as json" do
    post room_price_hotel_url(@hotel), params: { room_type: "single_room" }
    assert_response :success
    assert_equal @hotel.single_room_price, JSON.parse(response.body)["room_price"]
  end
end
