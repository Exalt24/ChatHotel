class CreateHotels < ActiveRecord::Migration[7.2]
  def change
    create_table :hotels do |t|
      t.string :name
      t.text :description
      t.string :location
      t.string :contact_details
      t.string :amenities
      t.integer :single_room_price
      t.integer :double_room_price
      t.integer :suite_price

      t.timestamps
    end
  end
end
