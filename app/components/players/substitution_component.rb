# frozen_string_literal: true

class Players::SubstitutionComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @volleyball_set = @player.volleyball_set
    @previous_substitution = previous_substitution
    @bench_players = @volleyball_set.ordered_players.bench.where(starting_libero: nil)
    @bench_players = @bench_players.excluding(@previous_substitution) if @previous_substitution.present?
  end

  def render?
    @player.persisted? && @player.team == @player.game.home_team && !@player.volleyball_libero?
  end

  def previous_substitution
    substitutions = @volleyball_set.events.substitution.where(incoming_player: @player)
    return nil if substitutions.empty?

    substitutions.last.player
  end
end
