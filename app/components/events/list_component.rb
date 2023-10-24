# frozen_string_literal: true

class Events::ListComponent < ApplicationComponent
  def initialize(volleyball_set:)
    @volleyball_set = volleyball_set
  end
end
