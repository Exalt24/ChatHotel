json.extract! admin_hotel, :id, :name, :description, :location, :contact_details, :amenities, :single_room_price, :double_room_price, :suite_price, :created_at, :updated_at

json.url admin_hotel_url(admin_hotel, format: :json)

# Example: Include image URLs
if admin_hotel.images.attached?
  json.images do
    admin_hotel.images.each do |image|
      json.image_url url_for(image)
    end
  end
end
