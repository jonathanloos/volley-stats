class VolleyballSet < ApplicationRecord
  include ActiveModel::Dirty

  ROTATIONS = [1, 2, 3, 4, 5, 6]

  belongs_to :game
  belongs_to :serving_team, class_name: "Team"
  belongs_to :receiving_team, class_name: "Team"

  acts_as_list scope: :game

  has_many :players, dependent: :destroy
  has_many :users, through: :players
  has_many :events, -> { order(:position) }, dependent: :destroy

  validates :starting_setter_rotation, numericality: {in: 1..6}, if: -> { persisted? }
  validates :home_time_outs_left, numericality: {greater_than_or_equal_to: 0}
  validates :away_time_outs_left, numericality: {greater_than_or_equal_to: 0}

  before_save :set_serving_and_receiving_teams

  def to_s
    "#{game} - Set #{position}"
  end

  def all_rotations_covered?
    players.where.not(rotation: nil).count == 6
  end

  def active_players
    players.where.not(rotation: nil)
  end

  def home_team_serving?
    points = events.points
    return true if points.empty? && serving_team == game.home_team

    return false if points.empty?
    return true if points.last.point_earned? && points.last.team == game.home_team
    return true if points.last.point_given? && points.last.team == game.away_team

    false
  end

  def away_team_serving?
    points = events.points
    return true if points.empty? && serving_team == game.away_team

    return false if points.empty?
    return true if points.last.point_earned? && points.last.team == game.away_team
    return true if points.last.point_given? && points.last.team == game.home_team

    false
  end

  def has_valid_starting_lineup?
    return false unless (ROTATIONS - active_players.pluck(:rotation)).empty?

    valid_starting_lineup = true

    # check front/back row positions
    players.where(rotation: [1,2,3]).on_court.each do |player|
      next if player.rotation.nil?

      opposite_rotation = if player.rotation == 1
        4
      elsif player.rotation == 2
        5
      elsif player.rotation == 3
        6
      end

      # if all rotations other than the opposite rotation play front/back in different places it is valid (no double up)
      valid_starting_lineup &&= players.excluding(player).where.not(rotation: [opposite_rotation, nil]).where(back_row_position: player.back_row_position).or(
        players.excluding(player).where.not(rotation: [opposite_rotation, nil]).where(front_row_position: player.front_row_position)
      ).empty?
    end

    return valid_starting_lineup
  end

  def in_rally?
    events.last.continuation?
  end

  def away_team_player
    Player.find_by(volleyball_set: self, team: game.away_team)
  end

  def ordered_players
    players.joins(:user).where(users: {role: :player}).order("users.jersey_number", position: :asc)
  end

  private

  def set_serving_and_receiving_teams
    return unless serving_team_id_changed?

    if serving_team == game.home_team
      self.receiving_team = game.away_team
    else
      self.receiving_team = game.home_team
    end
  end
end
