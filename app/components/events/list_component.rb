# frozen_string_literal: true

class Events::ListComponent < ApplicationComponent
  def initialize(events:)
    @events = events
  end
end
