module PricingHelper
  extend ActiveSupport::Concern

  def self.room_price_for_type(hotel, room_type)
    case room_type
    when "single_room"
      hotel.single_room_price
    when "double_room"
      hotel.double_room_price
    when "suite"
      hotel.suite_price
    else
      0
    end
  end

  def self.calculate_total_cost(start_date, end_date, room_price, hotel)
    if start_date && end_date && room_price
      additional_price = additional_price_based_on_day(start_date)
      total_cost = ((end_date - start_date).to_i + 1) * (room_price + additional_price)
      total_cost
    else
      0
    end
  end

  def self.additional_price_based_on_day(date)
    day_of_week = date.strftime("%A").capitalize
    day_adjustment = DayPriceAdjustment.find_by(day_of_week: day_of_week)

    if day_adjustment
      day_adjustment.price_adjustment
    else
      0
    end
  end
end
