class CreateBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :hotel, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :room_type
      t.integer :total_cost
      t.string :status, default: "confirmed"
      t.string :booked_name
      t.string :booked_number

      t.timestamps
    end
  end
end
