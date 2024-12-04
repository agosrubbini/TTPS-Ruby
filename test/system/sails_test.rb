require "application_system_test_case"

class SailsTest < ApplicationSystemTestCase
  setup do
    @sail = sails(:one)
  end

  test "visiting the index" do
    visit sails_url
    assert_selector "h1", text: "Sails"
  end

  test "should create sail" do
    visit sails_url
    click_on "New sail"

    fill_in "Client dni", with: @sail.client_dni
    fill_in "Completed at", with: @sail.completed_at
    fill_in "Employee", with: @sail.employee_id
    fill_in "Total amount", with: @sail.total_amount
    click_on "Create Sail"

    assert_text "Sail was successfully created"
    click_on "Back"
  end

  test "should update Sail" do
    visit sail_url(@sail)
    click_on "Edit this sail", match: :first

    fill_in "Client dni", with: @sail.client_dni
    fill_in "Completed at", with: @sail.completed_at.to_s
    fill_in "Employee", with: @sail.employee_id
    fill_in "Total amount", with: @sail.total_amount
    click_on "Update Sail"

    assert_text "Sail was successfully updated"
    click_on "Back"
  end

  test "should destroy Sail" do
    visit sail_url(@sail)
    click_on "Destroy this sail", match: :first

    assert_text "Sail was successfully destroyed"
  end
end
