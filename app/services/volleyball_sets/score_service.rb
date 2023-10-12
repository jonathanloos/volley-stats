# This class will create a crew member
class VolleyballSets::ScoreService < ApplicationService
  def initialize(volleyball_set:, event:)
    @volleyball_set = volleyball_set
    @event = event
  end

  def call
    VolleyballSet.transaction do
      return true unless @event.point_earned? || @event.point_given?

      if @event.point_earned?
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
