class ReviewsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [ :new, :create ]

  def new
    @hotel = Hotel.find(params[:hotel_id])
    @review = @hotel.reviews.build
  end

  def create
    @hotel = Hotel.find(params[:hotel_id])  # Ensure @hotel is set for error handling
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.hotel_id = params[:hotel_id]

    if @review.save
      redirect_to @review.hotel, notice: "Review was successfully created."
    else
      render :new
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to hotels_path, alert: "Hotel not found."
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end
end
