class Admin::HotelsController < AdminController
  before_action :admin_hotel_params
  before_action :set_admin_hotel, only: [ :show, :edit, :update, :destroy ]

  def index
    @admin_hotels = Hotel.all

    # Apply search filter if search params are present
    if params[:search].present?
      search_term = params[:search].downcase
      @admin_hotels = @admin_hotels.where("LOWER(name) LIKE :search OR LOWER(location) LIKE :search", search: "%#{search_term}%")
    end

    if params[:id].present?
      @admin_hotels = Hotel.where(id: params[:id])
    end

    # Sort hotels by name ascending or descending based on params[:order]
    if params[:order] == "name_asc"
      @admin_hotels = @admin_hotels.order(name: :asc)
    elsif params[:order] == "name_desc"
      @admin_hotels = @admin_hotels.order(name: :desc)
    elsif params[:order] == "id_asc"
      @admin_hotels = @admin_hotels.order(id: :asc)
    elsif params[:order] == "id_desc"
      @admin_hotels = @admin_hotels.order(id: :desc)
    else
      @admin_hotels = @admin_hotels.order(id: :asc)
    end

    @admin_hotels = @admin_hotels.paginate(page: params[:page], per_page: 10)
  end



  def show
  end

  def new
    @admin_hotel = Hotel.new
  end

  def create
    @admin_hotel = Hotel.new(admin_hotel_params)
    @admin_hotel.amenities = params[:hotel][:amenities].join(",") if params[:hotel][:amenities].present?

    # Logging parameters
    Rails.logger.info "Parameters submitted for create action: #{admin_hotel_params.inspect}"

    respond_to do |format|
      if @admin_hotel.save
        if params[:hotel][:images].present?
          @admin_hotel.images.attach(params[:hotel][:images])
        end
        format.html { redirect_to admin_hotel_url(@admin_hotel) }
        format.json { render :show, status: :created, location: @admin_hotel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    Rails.logger.info "Parameters submitted for update action: #{admin_hotel_params.inspect}"

    respond_to do |format|
      if @admin_hotel.update(admin_hotel_params.except(:images, :delete_images))
        # Handle image attachments
        if params[:hotel][:images].present?
          params[:hotel][:images].each do |image|
            @admin_hotel.images.attach(image)
          end
        end


      if params[:hotel][:delete_images].present?
        params[:hotel][:delete_images].each do |image_id|
          image = @admin_hotel.images.find_by_id(image_id)
          if image
            image.purge
            image.blob.purge
            Rails.logger.info "Deleted image #{image_id} from S3."
          else
            Rails.logger.warn "Image #{image_id} not found."
          end
        end
      end

        if params[:hotel][:amenities].present?
          @admin_hotel.amenities = params[:hotel][:amenities].join(",")
          @admin_hotel.save
        end

        format.html { redirect_to admin_hotel_url(@admin_hotel), notice: "Hotel was successfully updated." }
        format.json { render :show, status: :ok, location: @admin_hotel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_hotel.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_hotel.destroy!

    respond_to do |format|
      format.html { redirect_to admin_hotels_url, notice: "Hotel was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  def set_admin_hotel
    @admin_hotel = Hotel.find(params[:id])
  end

  def admin_hotel_params
    params.permit(
      :id, :search, :order, :page,
      :name, :description, :location, :contact_details,
      :single_room_price, :double_room_price, :suite_price,
      images: [],
      delete_images: [],
      amenities: []
    )
  end
end
