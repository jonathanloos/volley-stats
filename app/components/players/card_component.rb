# frozen_string_literal: true

class Players::CardComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @volleyball_set = @player.volleyball_set
    @most_recent_event = if @player.persisted?
      @player.events.last
    else
      @volleyball_set.events.where(team: @volleyball_set.game.away_team).last
    end
  end
end
