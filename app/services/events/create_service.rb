# This class will create an event
class Events::CreateService < ApplicationService
  def initialize(event:)
    @event = event
    @volleyball_set = @event.volleyball_set
    @event.game = @volleyball_set.game
    @event.setter_rotation = @volleyball_set.setter_rotation
    @event.team = @event.player.team
    @event.user = @event.player.user
    @event.role = @event.player.role
    @event.player_rotation = @event.player.rotation
  end

  def call
    Event.transaction do
      # rotate players
      Players::RotateService.call(players: @volleyball_set.active_players, most_recent_event: @event)

      # adjust points
      VolleyballSets::ScoreService.call(volleyball_set: @volleyball_set, most_recent_event: @event)

      # log timeouts
      if @event.timeout?
        if @event.team == @volleyball_set.game.home_team
          @volleyball_set.home_time_outs_left -= 1 if @volleyball_set.home_time_outs_left > 0
        else
          @volleyball_set.away_time_outs_left -= 1 if @volleyball_set.away_time_outs_left > 0
        end
        @volleyball_set.save!
      end

      # update the event score cache
      @event.home_score = @volleyball_set.home_score
      @event.away_score = @volleyball_set.away_score
      @event.save!
    end
  rescue => e
    @event.errors.add(:base, e)
    false
  end
end
