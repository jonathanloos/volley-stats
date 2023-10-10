# This class will create a crew member
class Players::RotateService < ApplicationService
  def initialize(players:)
    @players = players
    @volleyball_set = @players.first.volleyball_set
  end

  def call
    Event.transaction do
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
    second_last_event = @volleyball_set.events.second_to_last
    last_event = @volleyball_set.events.last
    
    # only ever rotate on a won point
    return false unless last_event.present? && last_event.point_earned?

    # todo: if the home team received first and they win a point, rotate
    return true if false && second_last_event.nil?

    # if the second last event was a lost point and the most recent event is a win, rotate
    return true if second_last_event.present? && second_last_event.point_given?

    # if the home team served first and they win points, don't rotate
    false
  end
end
