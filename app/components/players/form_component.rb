# frozen_string_literal: true

class Players::FormComponent < ApplicationComponent
  def initialize(player:)
    @player = player
  end

  def next_rotation
    if !@player.volleyball_set.all_rotations_covered? && @player.volleyball_set.players.where.not(rotation: nil).any?
      @player.volleyball_set.players.where.not(rotation: nil).last.rotation + 1
    end
  end

  def form_model
    if @player.persisted?
      @player
    else
      [@player.volleyball_set, @player]
    end
  end
end
