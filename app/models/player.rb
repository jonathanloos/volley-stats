class Player < ApplicationRecord
  include Roleable

  belongs_to :user
  belongs_to :game
  belongs_to :volleyball_set

  delegate :jersey_number, to: :user
  
  has_many :events, -> { order(:position) }, dependent: :destroy

  validates :role, presence: true, if: -> { on_court? }
  validates :rotation, numericality: {in: 1..6}, uniqueness: {scope: :volleyball_set, message: "must not have two players in the same rotation"}, if: -> {rotation.present? && on_court?}

  before_validation :set_status

  enum status: {
    on_court: 0,
    bench: 1
  }

  def to_s
    "#{user.first_name} #{user.last_name[0]}"
  end

  def serving?
    return false unless rotation == 1

    volleyball_set.home_team_serving?
  end

  private

  def set_status
    self.status = rotation.present? ? :on_court : :bench
  end
end
