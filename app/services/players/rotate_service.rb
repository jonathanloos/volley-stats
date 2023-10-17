# This class will create a crew member
class Players::RotateService < ApplicationService
  def initialize(players:, most_recent_event:)
    @players = players
    @volleyball_set = @players.first.volleyball_set
    @most_recent_event = most_recent_event
  end

  def call
    Player.transaction do
      return true unless should_rotate?

      # cache the setter rotation on the set
      if @volleyball_set.setter_rotation == 1
        @volleyball_set.update(setter_rotation: 6)
      else
        @volleyball_set.update(setter_rotation: @volleyball_set.setter_rotation - 1)
      end

      # iterate through players and update their rotation
      @players.each do |player|
        if player.rotation == 1
          player.update(rotation: 6)
        else
          player.update(rotation: player.rotation - 1)
        end
      end

      true
    end
  rescue => e
    @volleyball_set.errors.add(:base, e)
    false
  end

  def should_rotate?
    points = @volleyball_set.events.where(category: [:point_earned, :point_given])

    # only ever rotate on a won point
    return false unless @most_recent_event.point_earned?

    # if the home team is serving and they win points off the start
    return false if points.point_given.empty? && @volleyball_set.serving_team == @most_recent_event.team

    # if the home team received first and they win a point, rotate
    return true if points.point_earned.empty? && @volleyball_set.receiving_team == @most_recent_event.team

    # if the second last event was a lost point and the most recent event is a win, rotate
    return true if points.last.present? && points.last.point_given?

    # if the home team served first and they win points, don't rotate
    false
  end
end
