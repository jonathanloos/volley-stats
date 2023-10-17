# frozen_string_literal: true

class Players::FormComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @volleyball_set = @player.volleyball_set
  end

  def next_rotation
    return @volleyball_set.starting_setter_rotation if @volleyball_set.active_players.empty?

    if !@volleyball_set.all_rotations_covered? && @volleyball_set.active_players.any?
      @volleyball_set.active_players.last.rotation + 1
    end
  end

  def form_model
    if @player.persisted?
      @player
    else
      [@volleyball_set, @player]
    end
  end
end
