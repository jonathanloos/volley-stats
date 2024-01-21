# This class will 
class VolleyballSets::TimeoutService < ApplicationService
  def initialize(event:, volleyball_set:, undo_action: false)
    @event = event
    @volleyball_set = volleyball_set
    @undo_action = undo_action
  end

  def call
    VolleyballSet.transaction do
      return true unless @event.timeout?

      if @undo_action
        # log timeouts
        if @event.team == @volleyball_set.game.home_team
          raise unless @volleyball_set.home_time_outs_left < 2
          @volleyball_set.home_time_outs_left += 1

        else
          raise unless @volleyball_set.away_time_outs_left < 2
          @volleyball_set.away_time_outs_left += 1
        end
      else
        # log timeouts
        if @event.team == @volleyball_set.game.home_team
          raise unless @volleyball_set.home_time_outs_left > 0
          @volleyball_set.home_time_outs_left -= 1

        else
          raise unless @volleyball_set.away_time_outs_left > 0
          @volleyball_set.away_time_outs_left -= 1
        end
      end

      @volleyball_set.save!
    end
  rescue => e
    @event.errors.add(:base, e)
    false
  end
end
