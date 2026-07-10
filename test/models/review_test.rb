require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  def setup
    @review = Review.new(
      content: "Lovely stay, very clean rooms.",
      rating: 4,
      user: users(:one),
      hotel: hotels(:one)
    )
  end

  test "valid review is valid" do
    assert @review.valid?
  end

  test "content is required" do
    @review.content = ""
    assert_not @review.valid?
  end

  test "rating must be between one and five" do
    @review.rating = 0
    assert_not @review.valid?
    @review.rating = 6
    assert_not @review.valid?
    @review.rating = 3
    assert @review.valid?
  end

  test "rating must be an integer" do
    @review.rating = 2.5
    assert_not @review.valid?
  end
end
