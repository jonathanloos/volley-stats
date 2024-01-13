# frozen_string_literal: true

class Events::FormComponent < ApplicationComponent
  def initialize(event:)
    @event = event
    @player = @event.player
    @volleyball_set = @event.volleyball_set if @event.new_record?
  end
end
