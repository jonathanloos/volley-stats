# frozen_string_literal: true

class Players::FormComponent < ApplicationComponent
  def initialize(player:)
    @player = player
    @volleyball_set = @player.volleyball_set
  end
end
