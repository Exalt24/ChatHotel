class Hotel < ApplicationRecord
    has_many_attached :images
    has_many :bookings, dependent: :destroy
    has_many :reviews, dependent: :destroy

    validates :name, presence: true, length: { maximum: 50 }
    validates :description, presence: true
    VALID_MOBILE_REGEX = /\A(08|09)[0-9]{9}\z/
    validates :contact_details, presence: true, format: { with: VALID_MOBILE_REGEX, message: "must be a valid Philippine mobile number starting with 0" }
    validates :single_room_price, :double_room_price, :suite_price, presence: true
    validate :room_price_order
    validate :positive_room_prices

    private

    def room_price_order
      if single_room_price.present? && double_room_price.present? && suite_price.present?
        if single_room_price >= double_room_price
          errors.add(:single_room_price, "must be less than double room price")
        end

        if double_room_price >= suite_price
          errors.add(:double_room_price, "must be less than suite price")
        end

        if single_room_price >= suite_price
          errors.add(:single_room_price, "must be less than suite price")
        end
      end
    end

    def positive_room_prices
      if single_room_price.present? && double_room_price.present? && suite_price.present?
      if single_room_price <= 0
        errors.add(:single_room_price, "must be greater than 0")
      end

      if double_room_price <= 0
        errors.add(:double_room_price, "must be greater than 0")
      end

      if suite_price <= 0
        errors.add(:suite_price, "must be greater than 0")
      end
      end
  end
end
