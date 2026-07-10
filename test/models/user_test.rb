require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      first_name: "Grace",
      last_name: "Lim",
      email: "grace.lim@example.com",
      mobile_number: "09171234567",
      password: "secret123",
      password_confirmation: "secret123"
    )
  end

  test "valid user is valid" do
    assert @user.valid?
  end

  test "first and last name are required" do
    @user.first_name = ""
    assert_not @user.valid?
    @user.first_name = "Grace"
    @user.last_name = ""
    assert_not @user.valid?
  end

  test "email must match the expected format" do
    @user.email = "not-an-email"
    assert_not @user.valid?
  end

  test "email must be unique" do
    @user.save
    duplicate = @user.dup
    assert_not duplicate.valid?
  end

  test "email is downcased before saving" do
    @user.email = "Grace.LIM@Example.com"
    @user.save
    assert_equal "grace.lim@example.com", @user.reload.email
  end

  test "mobile number must be a valid PH mobile number" do
    @user.mobile_number = "12345"
    assert_not @user.valid?
    @user.mobile_number = "09171234567"
    assert @user.valid?
  end

  test "password must be at least six characters" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? returns false for a user with a nil digest" do
    assert_not @user.authenticated?(:remember, "")
  end
end
