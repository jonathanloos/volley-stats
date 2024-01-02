# frozen_string_literal: true

class Players::CardComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @volleyball_set = @player.volleyball_set
  end
end
