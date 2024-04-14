class Tournament < ApplicationRecord
  belongs_to :team
  has_many :games, dependent: :destroy
  has_many :volleyball_sets, through: :games

  def to_s
    title
  end

  def ordered_players
    players = Player.where(game: games)
    players.joins(:user).order("users.jersey_number", position: :asc)
  end
end
