class Player < ApplicationRecord
  include Roleable
  include Positionable

  FRONT_ROW_POSITIONS = [4, 3, 2]
  BACK_ROW_POSITIONS = [5, 6, 1]

  belongs_to :user, optional: true
  belongs_to :game
  belongs_to :volleyball_set
  belongs_to :team

  delegate :first_name, to: :user
  delegate :last_name, to: :user
  delegate :full_name, to: :user
  
  has_many :events, -> { order(:position) }

  validates :position, presence: true, if: -> { on_court? }
  validates :rotation, numericality: {in: 1..6}, uniqueness: {scope: :volleyball_set, message: "must not have two players in the same rotation"}, if: :check_rotation
  validates :user, presence: true, if: -> { game.home_team == team }
  validates :front_row_position, inclusion: {in: [nil, 2, 3, 4]}
  validates :back_row_position, inclusion: {in: [nil, 1, 6, 5]}
  before_validation :set_status
  before_validation :set_volleyball_position, on: :create
  before_validation :set_positions, on: :create

  scope :front_row, -> { on_court.where(rotation: [4,3,2]) }
  scope :back_row, -> { on_court.where(rotation: [5,6,1]) }
  scope :starting_lineup, -> { where.not(starting_rotation: nil) }

  enum status: {
    on_court: 0,
    bench: 1
  }

  def to_s
    if user.present?
      "#{first_name} #{last_name[0]}"
    else
      team.to_s
    end
  end

  def full_information
    if user.present?
      text = "#{jersey_number} - " + to_s
      text += " (#{position.humanize})" if position.present?
      text
    else
      team.to_s
    end
  end

  def serving?
    return true if team == volleyball_set.game.away_team && volleyball_set.away_team_serving?
    return false unless rotation == 1
    return false if volleyball_set.in_rally?

    volleyball_set.home_team_serving?
  end

  def jersey_number
    user.jersey_number if user.present?
  end

  def back_row?
    [5,6,1].include?(rotation)
  end

  def front_row?
    [4,3,2].include?(rotation)
  end

  def in_game_front_row_position
    return front_row_position unless serve_receive_rotation_one?

    return 2 if volleyball_left_side?
    return 4 if volleyball_right_side?
    3 # middle
  end

  def serve_receive_rotation_one?
    return false unless volleyball_set.setter_rotation == 1

    points = volleyball_set.events.points
    return true if points.empty? && volleyball_set.receiving_team == volleyball_set.game.home_team
    return false if points.empty?

    points.last.point_given? && points.last.team == volleyball_set.game.home_team ||
      points.last.point_earned? && points.last.team == volleyball_set.game.away_team
  end

  private

  def set_status
    self.status = rotation.present? ? :on_court : :bench
  end

  def check_rotation
    rotation.present? && on_court? && team != game.away_team && !user.coach?
  end

  def set_volleyball_position
    self.position = user.position if user.present?
  end

  def set_positions
    if volleyball_middle?
      self.back_row_position = 5
      self.front_row_position = 3
    elsif volleyball_setter?
      self.back_row_position = 1
      self.front_row_position = 2
    elsif volleyball_right_side?
      self.back_row_position = 1
      self.front_row_position = 2
    elsif volleyball_left_side?
      self.back_row_position = 6
      self.front_row_position = 4
    elsif volleyball_libero?
      self.back_row_position = 5
      self.front_row_position = 3
    else
      self.back_row_position = nil
      self.front_row_position = nil
    end
  end
end
