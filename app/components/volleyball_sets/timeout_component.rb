# frozen_string_literal: true

class VolleyballSets::TimeoutComponent < ApplicationComponent
  def initialize(volleyball_set:, home:)
    @volleyball_set = volleyball_set
    @home = home
    # TODO: Finish head coach implementation
    @user = if @home
      @volleyball_set.head_coach
    else
      @volleyball_set.
    end
    @event = Event.new
  end

end
