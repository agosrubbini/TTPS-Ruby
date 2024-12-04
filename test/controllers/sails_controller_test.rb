require "test_helper"

class SailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sail = sails(:one)
  end

  test "should get index" do
    get sails_url
    assert_response :success
  end

  test "should get new" do
    get new_sail_url
    assert_response :success
  end

  test "should create sail" do
    assert_difference("Sail.count") do
      post sails_url, params: { sail: { client_dni: @sail.client_dni, completed_at: @sail.completed_at, employee_id: @sail.employee_id, total_amount: @sail.total_amount } }
    end

    assert_redirected_to sail_url(Sail.last)
  end

  test "should show sail" do
    get sail_url(@sail)
    assert_response :success
  end

  test "should get edit" do
    get edit_sail_url(@sail)
    assert_response :success
  end

  test "should update sail" do
    patch sail_url(@sail), params: { sail: { client_dni: @sail.client_dni, completed_at: @sail.completed_at, employee_id: @sail.employee_id, total_amount: @sail.total_amount } }
    assert_redirected_to sail_url(@sail)
  end

  test "should destroy sail" do
    assert_difference("Sail.count", -1) do
      delete sail_url(@sail)
    end

    assert_redirected_to sails_url
  end
end
