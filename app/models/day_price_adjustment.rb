# app/models/day_price_adjustment.rb
class DayPriceAdjustment < ApplicationRecord
    validates :day_of_week, presence: true, uniqueness: true
    validates :price_adjustment, presence: true, numericality: { only_integer: true }
end
