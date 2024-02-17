class Game < ApplicationRecord
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"

  has_many :volleyball_sets, -> {order(position: :asc)}, dependent: :destroy
  has_many :players, -> {joins(:user).order("users.jersey_number", position: :asc)}, dependent: :destroy
  has_many :users, through: :players
  has_many :events, through: :volleyball_sets

  validates :title, presence: true
  validates :date, presence: true

  def to_s
    title
  end
end
