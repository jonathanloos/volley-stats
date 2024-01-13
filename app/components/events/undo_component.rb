# frozen_string_literal: true

class Events::UndoComponent < ApplicationComponent
  def initialize(event:)
    @event = event
  end

  def render?
    @event.present? && @event == @event.volleyball_set.events.last
  end
end
