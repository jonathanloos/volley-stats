require "test_helper"

class VolleyballSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @volleyball_set = volleyball_sets(:one)
  end

  test "should get index" do
    get volleyball_sets_url
    assert_response :success
  end

  test "should get new" do
    get new_volleyball_set_url
    assert_response :success
  end

  test "should create volleyball_set" do
    assert_difference("VolleyballSet.count") do
      post volleyball_sets_url, params: { volleyball_set: { game_id: @volleyball_set.game_id, order: @volleyball_set.order, team_id: @volleyball_set.team_id } }
    end

    assert_redirected_to volleyball_set_url(VolleyballSet.last)
  end

  test "should show volleyball_set" do
    get volleyball_set_url(@volleyball_set)
    assert_response :success
  end

  test "should get edit" do
    get edit_volleyball_set_url(@volleyball_set)
    assert_response :success
  end

  test "should update volleyball_set" do
    patch volleyball_set_url(@volleyball_set), params: { volleyball_set: { game_id: @volleyball_set.game_id, order: @volleyball_set.order, team_id: @volleyball_set.team_id } }
    assert_redirected_to volleyball_set_url(@volleyball_set)
  end

  test "should destroy volleyball_set" do
    assert_difference("VolleyballSet.count", -1) do
      delete volleyball_set_url(@volleyball_set)
    end

    assert_redirected_to volleyball_sets_url
  end
end
