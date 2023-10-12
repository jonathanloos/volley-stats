# This class will create a crew member
class Events::CreateService < ApplicationService
  def initialize(event:)
    @event = event
    @volleyball_set = @event.volleyball_set
    @event.game = @volleyball_set.game
    # todo: allow for away_team points
    @event.team = @volleyball_set.game.home_team
    @event.user = @event.player.user
    @event.role = @event.player.role
    @event.player_rotation = @event.player.rotation
    @event.setter_rotation = @volleyball_set.setter_rotation
  end

  def call
    Event.transaction do
      # save the event
      @event.save!

      # rotate players
      Players::RotateService.call(players: @volleyball_set.active_players)

      # adjust points
      VolleyballSets::ScoreService.call(volleyball_set: @volleyball_set)

      # update the event score cache
      @event.update(home_score: @volleyball_set.home_score, away_score: @volleyball_set.away_score)
    end
  rescue => e
    @event.errors.add(:base, e)
    false
  end
end
