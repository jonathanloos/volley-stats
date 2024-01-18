class Player < ApplicationRecord
  include Roleable
  include Positionable

  belongs_to :user, optional: true
  belongs_to :game
  belongs_to :volleyball_set
  belongs_to :team

  delegate :first_name, to: :user
  delegate :last_name, to: :user
  
  has_many :events, -> { order(:position) }, dependent: :destroy

  validates :position, presence: true, if: -> { on_court? }
  validates :rotation, numericality: {in: 1..6}, uniqueness: {scope: :volleyball_set, message: "must not have two players in the same rotation"}, if: -> {rotation.present? && on_court? && team != game.away_team}
  validates :user, presence: true, if: -> { game.home_team == team }
  before_validation :set_status

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
      text += " (#{user.role.humanize})" if user.role.present?
      text
    else
      team.to_s
    end
  end

  def serving?
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
end
