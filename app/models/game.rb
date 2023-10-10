class Game < ApplicationRecord
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"

  has_many :volleyball_sets, dependent: :destroy
  has_many :players, dependent: :destroy

  def to_s
    title
  end
end
