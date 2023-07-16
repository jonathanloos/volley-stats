require "application_system_test_case"

class VolleyballSetsTest < ApplicationSystemTestCase
  setup do
    @volleyball_set = volleyball_sets(:one)
  end

  test "visiting the index" do
    visit volleyball_sets_url
    assert_selector "h1", text: "Volleyball sets"
  end

  test "should create volleyball set" do
    visit volleyball_sets_url
    click_on "New volleyball set"

    fill_in "Game", with: @volleyball_set.game_id
    fill_in "Order", with: @volleyball_set.order
    fill_in "Team", with: @volleyball_set.team_id
    click_on "Create Volleyball set"

    assert_text "Volleyball set was successfully created"
    click_on "Back"
  end

  test "should update Volleyball set" do
    visit volleyball_set_url(@volleyball_set)
    click_on "Edit this volleyball set", match: :first

    fill_in "Game", with: @volleyball_set.game_id
    fill_in "Order", with: @volleyball_set.order
    fill_in "Team", with: @volleyball_set.team_id
    click_on "Update Volleyball set"

    assert_text "Volleyball set was successfully updated"
    click_on "Back"
  end

  test "should destroy Volleyball set" do
    visit volleyball_set_url(@volleyball_set)
    click_on "Destroy this volleyball set", match: :first

    assert_text "Volleyball set was successfully destroyed"
  end
end
