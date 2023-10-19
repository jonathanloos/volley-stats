# This class will create a crew member
class Events::DestroyService < ApplicationService
  def initialize(event:)
    @event = event
    @volleyball_set = @event.volleyball_set
  end

  def call
    Event.transaction do
      # update the event score cache
      @event.destroy

      # rotate players
      Players::RotateService.call(players: @volleyball_set.active_players, most_recent_event: @event, undo_action: true)

      # adjust points
      VolleyballSets::ScoreService.call(volleyball_set: @volleyball_set, most_recent_event: @event, undo_action: true)
    end
  rescue => e
    @event.errors.add(:base, e)
    false
  end
end
