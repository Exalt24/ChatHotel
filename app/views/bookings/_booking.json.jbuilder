json.extract! booking, :id, :user_id, :hotel_id, :start_date, :end_date, :room_type, :status, :created_at, :updated_at
json.url booking_url(booking, format: :json)
