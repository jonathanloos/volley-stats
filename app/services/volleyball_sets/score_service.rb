# This class will adjust the score based on the most recent event.
class VolleyballSets::ScoreService < ApplicationService
  def initialize(volleyball_set:, most_recent_event:, undo_action: false)
    @volleyball_set = volleyball_set
    @most_recent_event = most_recent_event
    @undo_action = undo_action
  end

  def call
    VolleyballSet.transaction do
      return true unless @most_recent_event.point_earned? || @most_recent_event.point_given?

      if @undo_action
        if home_team_point?
          @volleyball_set.update(home_score: @volleyball_set.home_score - 1)
        else
          @volleyball_set.update(away_score: @volleyball_set.away_score - 1)
        end
      else
        if home_team_point?
          @volleyball_set.update(home_score: @volleyball_set.home_score + 1)
        else
          @volleyball_set.update(away_score: @volleyball_set.away_score + 1)
        end
      end
    end
  rescue => e
    @volleyball_set.errors.add(:base, e)
    false
  end

  def home_team_point?
    (@most_recent_event.point_earned? && @most_recent_event.team == @volleyball_set.game.home_team) ||
      (@most_recent_event.point_given? && @most_recent_event.team == @volleyball_set.game.away_team)
  end
end
