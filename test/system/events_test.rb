require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "should create event" do
    visit events_url
    click_on "New event"

    fill_in "Continuation", with: @event.continuation
    fill_in "Earned", with: @event.earned
    fill_in "Game", with: @event.game_id
    fill_in "Given", with: @event.given
    fill_in "Rotation", with: @event.rotation
    fill_in "Team", with: @event.team_id
    fill_in "User", with: @event.user_id
    fill_in "Volleyball set", with: @event.volleyball_set_id
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "should update Event" do
    visit event_url(@event)
    click_on "Edit this event", match: :first

    fill_in "Continuation", with: @event.continuation
    fill_in "Earned", with: @event.earned
    fill_in "Game", with: @event.game_id
    fill_in "Given", with: @event.given
    fill_in "Rotation", with: @event.rotation
    fill_in "Team", with: @event.team_id
    fill_in "User", with: @event.user_id
    fill_in "Volleyball set", with: @event.volleyball_set_id
    click_on "Update Event"

    assert_text "Event was successfully updated"
    click_on "Back"
  end

  test "should destroy Event" do
    visit event_url(@event)
    click_on "Destroy this event", match: :first

    assert_text "Event was successfully destroyed"
  end
end
