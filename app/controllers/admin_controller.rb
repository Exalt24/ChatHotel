class AdminController < ApplicationController
  layout "admin"
  before_action :require_admin

  def index
    @customers = User.where(admin: false)
    @admins = User.where(admin: true)
    @confirmed_bookings = Booking.where(status: "confirmed")
    @cancelled_bookings = Booking.where(status: "cancelled")
    @hotels = Hotel.all
  end

  private

    def require_admin
      unless current_user&.admin?
        flash[:error] = "Access denied"
        redirect_to root_path
      end
    end
end
