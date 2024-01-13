# frozen_string_literal: true

class VolleyballSets::ScoreComponent < ApplicationComponent
  def initialize(volleyball_set:)
    @volleyball_set = volleyball_set
  end
end
