class Game < ApplicationRecord
  belongs_to :team
  has_many :volleyball_sets, -> { order(order: :asc) }
  has_many :players

  def to_s
    title
  end
end
