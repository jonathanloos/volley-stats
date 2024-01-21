# frozen_string_literal: true

class Players::CardComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @volleyball_set = @player.volleyball_set
    @most_recent_event = @player.events.not_timeout.last || Event.new(player: @player, volleyball_set: @volleyball_set)
  end
end
