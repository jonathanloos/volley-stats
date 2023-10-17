class VolleyballSet < ApplicationRecord
  include ActiveModel::Dirty

  belongs_to :game
  belongs_to :serving_team, class_name: "Team"
  belongs_to :receiving_team, class_name: "Team"

  acts_as_list scope: :game

  has_many :players, -> { joins(:user).order("users.jersey_number", role: :asc) }, dependent: :destroy
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
    (events.empty? && serving_team == game.home_team) || (events.where(category: [:point_earned, :point_given]).any? && events.where(category: [:point_earned, :point_given]).last.point_earned?)
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
