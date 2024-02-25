# frozen_string_literal: true

class VolleyballSets::StartingLineupComponent < ApplicationComponent
  def initialize(volleyball_set:)
    @volleyball_set = volleyball_set
    @players = @volleyball_set.players
  end

end
