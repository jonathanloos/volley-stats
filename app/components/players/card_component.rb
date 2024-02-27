# frozen_string_literal: true

class Players::CardComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @volleyball_set = @player.volleyball_set
    @most_recent_event = @player.events.not_timeout.last || Event.new(player: @player, volleyball_set: @volleyball_set)
  end

  def rotation_number
    if @volleyball_set.in_rally?
      # TODO: Make this not bad
      return 1 if @player.back_row? && @player.back_row_position_right?
      return 2 if @player.front_row? && @player.front_row_position_right?
      return 3 if @player.front_row? && @player.front_row_position_center?
      return 4 if @player.front_row? && @player.front_row_position_left?
      return 5 if @player.back_row? && @player.back_row_position_left?
      return 6 if @player.back_row? && @player.back_row_position_center?
    else
      @player.rotation || @player.team.name.underscore
    end
  end
end
