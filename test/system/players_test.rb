require "application_system_test_case"

class PlayersTest < ApplicationSystemTestCase
  setup do
    @player = players(:one)
  end

  test "visiting the index" do
    visit players_url
    assert_selector "h1", text: "Players"
  end

  test "should create player" do
    visit players_url
    click_on "New player"

    fill_in "Game", with: @player.game_id
    fill_in "Position", with: @player.position
    fill_in "User", with: @player.user_id
    fill_in "Volleyball set", with: @player.volleyball_set_id
    click_on "Create Player"

    assert_text "Player was successfully created"
    click_on "Back"
  end

  test "should update Player" do
    visit player_url(@player)
    click_on "Edit this player", match: :first

    fill_in "Game", with: @player.game_id
    fill_in "Position", with: @player.position
    fill_in "User", with: @player.user_id
    fill_in "Volleyball set", with: @player.volleyball_set_id
    click_on "Update Player"

    assert_text "Player was successfully updated"
    click_on "Back"
  end

  test "should destroy Player" do
    visit player_url(@player)
    click_on "Destroy this player", match: :first

    assert_text "Player was successfully destroyed"
  end
end
