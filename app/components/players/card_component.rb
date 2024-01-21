# frozen_string_literal: true

class Players::CardComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @volleyball_set = @player.volleyball_set
    # debugger if @player.team == @volleyball_set.game.away_team
    @most_recent_event = @player.events.not_timeout.last
  end
end
