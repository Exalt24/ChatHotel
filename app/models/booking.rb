class Booking < ApplicationRecord
  include PricingHelper
  belongs_to :user
  belongs_to :hotel

  enum status: {
    confirmed: "confirmed",
    cancelled: "cancelled"
  }

  enum room_type: {
    single_room: "single_room",
    double_room: "double_room",
    suite: "suite"
  }

  validates :start_date, :end_date, presence: true
  validate :dates_are_valid
  validate :no_double_booking
  validates :room_type, presence: true
  validates :total_cost, presence: true
  validates :booked_name, :booked_number, presence: true

  before_validation :set_total_cost

  def send_booking_email
    UserMailer.booking_confirmation(self).deliver_now
  end

  private

  def dates_are_valid
    if start_date && !start_date.is_a?(Date)
      errors.add(:start_date, "must be a valid date")
    end

    if end_date && !end_date.is_a?(Date)
      errors.add(:end_date, "must be a valid date")
    end

    if start_date && start_date < Date.today
      errors.add(:start_date, "cannot be in the past")
    end

    if start_date && end_date && end_date < start_date
      errors.add(:end_date, "must be equal to or after start date")
    end
  end

  def no_double_booking
    conflicting_booking = Booking.where(hotel_id: hotel_id, room_type: room_type)
                                 .where("start_date <= ? AND end_date >= ?", end_date, start_date)
                                 .where.not(id: id) # Exclude current booking from the check if updating
                                 .where(status: "confirmed") # Consider only confirmed bookings

    if conflicting_booking.exists?
      conflicting_dates = conflicting_booking.pluck(:start_date, :end_date).map { |sd, ed| "#{sd} to #{ed}" }.join(", ")
      errors.add(:base, "Room is already booked for the following confirmed dates: #{conflicting_dates}.")
    end
  end

  def set_total_cost
    self.total_cost = PricingHelper.calculate_total_cost(start_date, end_date, PricingHelper.room_price_for_type(hotel, room_type), hotel) if start_date && end_date && PricingHelper.room_price_for_type(hotel, room_type)
  end
end
