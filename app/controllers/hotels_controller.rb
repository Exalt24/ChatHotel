class HotelsController < ApplicationController
  # GET /hotels or /hotels.json
  def index
    @hotels = Hotel.all
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
