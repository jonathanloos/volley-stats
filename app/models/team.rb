class Team < ApplicationRecord
  has_many :users
  has_many :volleyball_sets
  belongs_to :head_coach, class_name: "User", optional: true
  belongs_to :assistant_coach, class_name: "User", optional: true
  belongs_to :organization, optional: true

  def to_s
    name
  end

  def games
    Game.where(home_team: self).or(Game.where(away_team: self))
  end

  def tournaments
    Tournament.where(id: games.pluck(:tournament_id))
  end
end
