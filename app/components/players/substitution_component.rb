# frozen_string_literal: true

class Players::SubstitutionComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @bench_players = @player.volleyball_set.players.bench
  end

  def render?
    @player.persisted?
  end
end
