class VolleyballSet < ApplicationRecord
  belongs_to :game
  belongs_to :serving_team, class_name: "Team"
  belongs_to :receiving_team, class_name: "Team"

  acts_as_list scope: :game

  has_many :players, -> { order(rotation: :asc, role: :asc) }, dependent: :destroy
  has_many :events, dependent: :destroy

  validates :starting_setter_rotation, numericality: {in: 1..6}, if: -> { persisted? }

  def all_rotations_covered?
    players.where.not(rotation: nil).count == 6
  end

  def active_players
    players.where.not(rotation: nil)
  end

  def home_team_serving?
    (events.empty? && serving_team == game.home_team) || (events.where(category: [:point_earned, :point_given]).any? && events.where(category: [:point_earned, :point_given]).last.point_earned?)
  end
end
