class Game < ApplicationRecord
  belongs_to :team
  has_many :volleyball_sets, -> { order(order: :asc) }, dependent: :destroy
  has_many :players, dependent: :destroy

  def to_s
    title
  end
end
