class VolleyballSet < ApplicationRecord
  include ActiveModel::Dirty

  ROTATIONS = [1, 2, 3, 4, 5, 6]

  belongs_to :game
  belongs_to :serving_team, class_name: "Team"
  belongs_to :receiving_team, class_name: "Team"

  acts_as_list scope: :game

  has_many :players, -> { joins(:user).order("users.jersey_number", role: :asc) }, dependent: :destroy
  has_many :users, through: :players
  has_many :events, -> { order(:position) }, dependent: :destroy

  validates :starting_setter_rotation, numericality: {in: 1..6}, if: -> { persisted? }

  before_save :set_serving_and_receiving_teams

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

  def has_full_starting_lineup?
    (ROTATIONS - active_players.pluck(:rotation)).empty?
  end

  def away_team_player
    Player.find_by(volleyball_set: self, team: game.away_team)
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
