# frozen_string_literal: true

class Events::UndoComponent < ApplicationComponent
  def initialize(event:)
    @event = event
  end

  def render?
    return false unless @event.present? && @event.volleyball_set.events.any?

    last_event =  @event.volleyball_set.events.last
    return true if last_event == @event

    return false unless last_event.substitution? && last_event.incoming_player == @event.player

    @event = last_event
    true
  end
end
