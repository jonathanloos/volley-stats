class Game < ApplicationRecord
  belongs_to :team
  has_many :players

  def to_s
    title
  end
end
