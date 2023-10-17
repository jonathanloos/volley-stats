# frozen_string_literal: true

class Players::LineupComponent < ApplicationComponent
  def initialize(volleyball_set:)
    @volleyball_set = volleyball_set
  end
end
