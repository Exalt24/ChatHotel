class BookingsController < ApplicationController
  before_action :set_hotel_and_current_user, only: [ :new, :create, :calculate_price ]
  before_action :logged_in_user, only: [ :index, :show, :new, :create, :destroy, :update, :cancel ]
  before_action :set_booking, only: %i[ show edit update destroy cancel ]
  before_action :correct_user, only: [ :cancel, :edit, :destroy ]

  # GET /bookings or /bookings.json
  def index
    @bookings = current_user.bookings

    if params[:filter].present?
      case params[:filter]
      when "confirmed"
        @bookings = @bookings.where(status: "confirmed")
      when "cancelled"
        @bookings = @bookings.where(status: "cancelled")
      end
    end

    @bookings = @bookings.paginate(page: params[:page], per_page: 5)
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new

  def new
    @booking = Booking.new
    if params[:hotel_id].present?
      @hotel = Hotel.find_by(id: params[:hotel_id])
      if @hotel.nil?
        redirect_to hotels_path
        return
      end
    else
      redirect_to hotels_path
      return
    end

    @booking.booked_name = "#{current_user.first_name} #{current_user.last_name}"
    @booking.booked_number = current_user.mobile_number # Adjust based on your actual attribute name
  end


  # POST /bookings/cancel/1
  def cancel
    if @booking.update(status: "cancelled")
      redirect_to booking_path(@booking)
    else
      redirect_to booking_path(@booking)
    end
  end

  # GET /bookings/1/edit
  def edit
  end

  def calculate_price
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
    room_type = params[:room_type]
    hotel = Hotel.find(params[:hotel_id])

    room_price = PricingHelper.room_price_for_type(hotel, room_type)
    total_cost = PricingHelper.calculate_total_cost(start_date, end_date, room_price, hotel)

    render json: { total_cost: total_cost }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

def create
  @booking = Booking.new(booking_params)
  @booking.user_id = current_user.id
  @booking.start_date = params[:start_date]
  @booking.end_date = params[:end_date]
  @booking.booked_name = "#{current_user.first_name} #{current_user.last_name}"
  @booking.booked_number = current_user.mobile_number # Adjust based on your actual attribute name

  respond_to do |format|
    if @booking.save
      @booking.send_booking_email
      format.html { redirect_to booking_url(@booking) }
      format.json { render :show, status: :created, location: @booking }
    else
      # Reload @hotel and set booked_name and booked_number again
      @hotel = Hotel.find_by(id: params[:booking][:hotel_id])
      @booking.booked_name = "#{current_user.first_name} #{current_user.last_name}"
      @booking.booked_number = current_user.mobile_number # Adjust based on your actual attribute name
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @booking.errors, status: :unprocessable_entity }
    end
  end
end


  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to booking_url(@booking), notice: "Booking was successfully updated." }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy!

    respond_to do |format|
      format.html { redirect_to bookings_url, notice: "Booking was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def set_hotel_and_current_user
      @current_user = current_user
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:id, :start_date, :end_date, :room_type, :room_price, :total_cost, :hotel_id, :user_id, :status)
    end

    def correct_user
      @booking = current_user.bookings.find_by(id: params[:id])
      if @booking.nil?
        puts "Redirecting to root_url because booking with ID #{params[:id]} does not belong to current user."
        redirect_to root_url
      else
        puts "Booking found: #{@booking.attributes}"
      end
    end

end
