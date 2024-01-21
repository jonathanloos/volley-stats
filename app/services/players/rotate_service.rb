# This class will rotate players into their next position
class Players::RotateService < ApplicationService
  def initialize(players:, most_recent_event:, undo_action: false)
    @players = players
    @volleyball_set = @players.first.volleyball_set
    @home_team = @volleyball_set.game.home_team
    @away_team = @volleyball_set.game.away_team
    @most_recent_event = most_recent_event
    @undo_action = undo_action
  end

  def call
    Player.transaction do
      return true unless should_rotate?

      if @undo_action
        # cache the setter rotation on the set
        if @volleyball_set.setter_rotation == 6
          @volleyball_set.update(setter_rotation: 1)
        else
          @volleyball_set.update(setter_rotation: @volleyball_set.setter_rotation + 1)
        end

        # iterate through players and update their rotation
        @players.each do |player|
          if player.rotation == 6
            player.update_column(:rotation, 1)
          else
            player.update_column(:rotation, player.rotation + 1)
          end
        end
      else
        # cache the setter rotation on the set
        if @volleyball_set.setter_rotation == 1
          @volleyball_set.update(setter_rotation: 6)
        else
          @volleyball_set.update(setter_rotation: @volleyball_set.setter_rotation - 1)
        end

        # iterate through players and update their rotation
        @players.each do |player|
          if player.rotation == 1
            player.update_column(:rotation, 6)
          else
            player.update_column(:rotation, player.rotation - 1)
          end
        end
      end

      true
    end
  rescue => e
    @volleyball_set.errors.add(:base, e)
    false
  end

  def should_rotate?
    points = @volleyball_set.events.points
    home_team_points = points.where(team: @home_team)
    away_team_points = points.where(team: @away_team)

    # only ever rotate on a won point
    return false unless home_team_point?

    # don't rotate if the home team is serving and they haven't conceded a point
    return false if (home_team_points.point_given.empty? && away_team_points.point_earned.empty?) &&
      @volleyball_set.serving_team == @home_team

    # if the home team received first and they win a point, rotate
    return true if (home_team_points.point_earned.empty? && away_team_points.point_given.empty?) &&
      @volleyball_set.receiving_team == @home_team

    # if the second last event was a lost point and the most recent event is a win, rotate
    second_last_point = points.last
    return true if second_last_point.present? && (
      (second_last_point.point_given? && second_last_point.team == @home_team) || # home team lost a point
      (second_last_point.point_earned? && second_last_point.team == @away_team) # away team won a point
    )

    false
  end

  def home_team_point?
    (@most_recent_event.point_earned? && @most_recent_event.team == @home_team) ||
      (@most_recent_event.point_given? && @most_recent_event.team == @away_team)
  end
end
