# frozen_string_literal: true

class Players::CardComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @volleyball_set = @player.volleyball_set
    @most_recent_event = @player.events.not_timeout.last || Event.new(player: @player, volleyball_set: @volleyball_set)
  end

  def rotation_number
    if @volleyball_set.in_rally?
      return @player.back_row_position if @player.back_row?

      @player.in_game_front_row_position
    else
      @player.rotation
    end
  end
end
