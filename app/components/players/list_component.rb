# frozen_string_literal: true

class Players::ListComponent < ApplicationComponent
  def initialize(volleyball_set:)
    @volleyball_set = volleyball_set
    @players = @volleyball_set.players
    @new_player = Player.new(volleyball_set: @volleyball_set, game: @volleyball_set.game)
  end
end
