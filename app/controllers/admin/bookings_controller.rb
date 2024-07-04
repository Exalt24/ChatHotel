class Admin::BookingsController < AdminController

    before_action :set_booking, only: [ :show, :toggle_status, :destroy ]

  def index
    @admin_bookings = Booking.all

    if params[:id].present?
      @admin_bookings = Booking.where(id: params[:id])
    end

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      if start_date > end_date
        flash[:error] = "Start date cannot be after end date."
        redirect_to admin_bookings_path
      end

      @admin_bookings = @admin_bookings.where(start_date: start_date.beginning_of_day..end_date.end_of_day)
    elsif params[:start_date].present?
      start_date = Date.parse(params[:start_date])
      @admin_bookings = @admin_bookings.where("start_date >= ?", start_date.beginning_of_day)
    elsif params[:end_date].present?
      end_date = Date.parse(params[:end_date])
      @admin_bookings = @admin_bookings.where("end_date <= ?", end_date.end_of_day)
    end

    # Handle user_id and hotel_id filtering
    @admin_bookings = @admin_bookings.where(user_id: params[:user_id]) if params[:user_id].present?
    @admin_bookings = @admin_bookings.where(hotel_id: params[:hotel_id]) if params[:hotel_id].present?

    if params[:status].present?
      @admin_bookings = @admin_bookings.where(status: params[:status])
    end

    if params[:order] == "user_id_asc"
      @admin_bookings = @admin_bookings.order(user_id: :asc)
    elsif params[:order] == "user_id_desc"
      @admin_bookings = @admin_bookings.order(user_id: :desc)
    elsif params[:order] == "id_asc"
      @admin_bookings = @admin_bookings.order(id: :asc)
    elsif params[:order] == "id_desc"
      @admin_bookings = @admin_bookings.order(id: :desc)
    elsif params[:order] == "hotel_id_asc"
      @admin_bookings = @admin_bookings.order(hotel_id: :asc)
    elsif params[:order] == "hotel_id_desc"
      @admin_bookings = @admin_bookings.order(hotel_id: :desc)
    else
      @admin_bookings = @admin_bookings.order(id: :asc)
    end

    @admin_bookings = @admin_bookings.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def toggle_status
    new_status = @admin_booking.status == "confirmed" ? "cancelled" : "confirmed"
    if @admin_booking.update(status: new_status)
      redirect_back fallback_location: admin_booking_path(@admin_booking), notice: "Booking status was successfully updated."
    else
      redirect_to admin_booking_path(@admin_booking), alert: "Failed to update booking status."
    end
  end


  def destroy
    @admin_booking.destroy
    redirect_to admin_bookings_path, notice: "Booking was successfully destroyed."
  end

  private

  def set_booking
    @admin_booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:id, :start_date, :end_date, :room_type, :room_price, :total_cost, :hotel_id, :user_id, :status)
  end
end
