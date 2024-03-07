# frozen_string_literal: true

class Players::LiberoSubstitutionComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @libero = @player.volleyball_set.players.find_by(starting_libero: true)
  end

  def render?
    return false if @libero.nil?
    return true if @player == @libero
    
    @player.back_row? && @libero.bench?
  end
end
