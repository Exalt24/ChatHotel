require "test_helper"

class DayPriceAdjustmentTest < ActiveSupport::TestCase
  test "valid adjustment is valid" do
    adjustment = DayPriceAdjustment.new(day_of_week: "Monday", price_adjustment: 200)
    assert adjustment.valid?
  end

  test "day_of_week is required" do
    adjustment = DayPriceAdjustment.new(day_of_week: "", price_adjustment: 200)
    assert_not adjustment.valid?
  end

  test "day_of_week must be unique" do
    adjustment = DayPriceAdjustment.new(day_of_week: day_price_adjustments(:one).day_of_week, price_adjustment: 100)
    assert_not adjustment.valid?
  end

  test "price adjustment cannot be negative" do
    adjustment = DayPriceAdjustment.new(day_of_week: "Tuesday", price_adjustment: -50)
    assert_not adjustment.valid?
  end
end
