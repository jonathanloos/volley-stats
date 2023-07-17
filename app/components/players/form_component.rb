# frozen_string_literal: true

class Players::FormComponent < ApplicationComponent
  def initialize(player:)
    @player = player
  end

  def form_model
    if @player.persisted?
      @player
    else
      [@player.volleyball_set, @player]
    end
  end
end
