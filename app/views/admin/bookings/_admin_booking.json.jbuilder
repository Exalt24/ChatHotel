json.extract! admin_user, :id, :start_date, :end_date, :room_type, :room_price, :total_cost, :hotel_id, :user_id

json.url admin_user_url(admin_user, format: :json)
