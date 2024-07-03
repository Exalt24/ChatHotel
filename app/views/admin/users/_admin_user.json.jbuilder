json.extract! admin_user, :id, :first_name, :last_name, :mobile_number, :admin

json.url admin_user_url(admin_user, format: :json)
