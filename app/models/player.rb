class Player < ApplicationRecord
  include Roleable

  belongs_to :user
  belongs_to :game
  belongs_to :volleyball_set

  has_many :events, dependent: :destroy

  validates :role, presence: true
  validates :rotation, numericality: {in: 1..6}, if: -> {rotation.present?}

  def to_s
    user.to_s
  end

  def serving?
    return false unless rotation == 1

    volleyball_set.home_team_serving?
  end
end
