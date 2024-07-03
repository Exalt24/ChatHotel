class CreateDayPriceAdjustments < ActiveRecord::Migration[6.0]
  def change
    create_table :day_price_adjustments do |t|
      t.string :day_of_week, null: false  # Remove unique: true
      t.integer :price_adjustment, default: 0

      t.timestamps
    end


    %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].each do |day|
      DayPriceAdjustment.create(day_of_week: day, price_adjustment: 0)
    end
  end
end
