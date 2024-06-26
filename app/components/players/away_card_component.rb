# frozen_string_literal: true

class Players::AwayCardComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @volleyball_set = @player.volleyball_set
    @most_recent_event = @player.events.not_timeout.last || Event.new(player: @player, volleyball_set: @volleyball_set)
  end

  def rotation_number
    if @volleyball_set.in_rally?
      return @player.back_row_position if @player.back_row?

      @player.front_row_position
    else
      @player.rotation || @player.team.name.underscore
    end
  end
end
