# frozen_string_literal: true

class Players::ListItemComponent < ApplicationComponent
  with_collection_parameter :player

  def initialize(player:)
    @player = player
  end
end
