# This class will create a crew member
class VolleyballSets::ScoreService < ApplicationService
  def initialize(volleyball_set:, most_recent_event:)
    @volleyball_set = volleyball_set
    @most_recent_event = most_recent_event
  end

  def call
    VolleyballSet.transaction do
      return true unless @most_recent_event.point_earned? || @most_recent_event.point_given?

      if @most_recent_event.point_earned?
        @volleyball_set.update(home_score: @volleyball_set.home_score + 1)
      else
        @volleyball_set.update(away_score: @volleyball_set.away_score + 1)
      end
    end
  rescue => e
    @volleyball_set.errors.add(:base, e)
    false
  end
end
