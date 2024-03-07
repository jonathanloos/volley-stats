# frozen_string_literal: true

class VolleyballSets::TimeoutComponent < ApplicationComponent
  def initialize(volleyball_set:, home:)
    @volleyball_set = volleyball_set
    @home = home

    if @home
      @player = @volleyball_set.players.find_by(user: @volleyball_set.game.home_team.head_coach)
      @timeouts_left = @volleyball_set.home_time_outs_left
    else
      @player = @volleyball_set.players.find_by(team: @volleyball_set.game.away_team)
      @timeouts_left = @volleyball_set.away_time_outs_left
    end

    @event = Event.new
    @most_recent_event = @player.events.timeout.last
  end
end
