# frozen_string_literal: true

class Players::ListComponent < ApplicationComponent
  def initialize(players:, volleyball_set:)
    @players = players
    @volleyball_set = volleyball_set
    @new_player = Player.new(volleyball_set: @volleyball_set, game: @volleyball_set.game)
  end
end
