class Player < ApplicationRecord
  include Roleable
  include Positionable

  belongs_to :user, optional: true
  belongs_to :game
  belongs_to :volleyball_set
  belongs_to :team

  delegate :first_name, to: :user
  delegate :last_name, to: :user
  
  has_many :events, -> { order(:position) }

  validates :position, presence: true, if: -> { on_court? }
  validates :rotation, numericality: {in: 1..6}, uniqueness: {scope: :volleyball_set, message: "must not have two players in the same rotation"}, if: :check_rotation
  validates :user, presence: true, if: -> { game.home_team == team }
  before_validation :set_status

  before_create :set_positions

  enum status: {
    on_court: 0,
    bench: 1
  }

  enum back_row_position: {
    left: 0,
    center: 1,
    right: 2,
    not_applicable: 3
  }, _prefix: true

  enum front_row_position: {
    left: 0,
    center: 1,
    right: 2,
    not_applicable: 3
  }, _prefix: true

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
      text += " (#{user.position.humanize})" if user.position.present?
      text
    else
      team.to_s
    end
  end

  def serving?
    return true if team == volleyball_set.game.away_team && volleyball_set.away_team_serving?
    return false unless rotation == 1

    volleyball_set.home_team_serving?
  end

  def jersey_number
    user.jersey_number if user.present?
  end

  private

  def set_status
    self.status = rotation.present? ? :on_court : :bench
  end

  def check_rotation
    rotation.present? && on_court? && team != game.away_team && !user.coach?
  end

  def set_positions
    if volleyball_middle?
      self.back_row_position = :left
      self.front_row_position = :center
    elsif volleyball_setter?
      self.back_row_position = :right
      self.front_row_position = :right
    elsif volleyball_right_side?
      self.back_row_position = :right
      self.front_row_position = :right
    elsif volleyball_left_side
      self.back_row_position = :center
      self.front_row_position = :left
    elsif volleyball_libero
      self.back_row_position = :left
      self.front_row_position = :not_applicable
    end
  end
end
