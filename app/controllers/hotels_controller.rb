class HotelsController < ApplicationController
  # GET /hotels or /hotels.json
  def index
    @hotels = Hotel.all

    if params[:location].present?
      @hotels = @hotels.where("location ILIKE ?", "%#{params[:location]}%")
    end

    if params[:start_date].present? || params[:end_date].present?
      if params[:start_date].blank? || params[:end_date].blank?
        flash.now[:alert] = "Please provide start date, end date, and room type for the search."
      else
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        room_type = params[:room_type]

        @hotels = @hotels.left_joins(:bookings).where.not(bookings: { start_date: start_date..end_date, room_type: room_type }).distinct
      end
    end

    @hotels = @hotels.paginate(page: params[:page], per_page: 9)
  end

  # GET /hotels/1 or /hotels/1.json
  def show
    @current_user = current_user
    @hotel = Hotel.find(params[:id])
  end

  def room_price
    hotel = Hotel.find(params[:id])
    room_type = params[:room_type]
    room_price = PricingHelper.room_price_for_type(hotel, room_type)

    render json: { room_price: room_price }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

    # Only allow a list of trusted parameters through.
    def hotel_params
      params.require(:hotel).permit(:id, :name, :description, :location, :contact_details, :amenities, :single_room_price, :double_room_price, :suite_price)
    end
end
