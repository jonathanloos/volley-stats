class VolleyballSet < ApplicationRecord
  belongs_to :game
  belongs_to :team

  has_many :players, -> { order(position: :asc) }, dependent: :destroy
  has_many :events, dependent: :destroy

  validates :starting_rotation, numericality: {in: 1..6}, if: -> { persisted? }

  before_validation :set_order

  validates :order, presence: true

  private

  def set_order
    self.order = if game.volleyball_sets.any?
      game.volleyball_sets.last.order + 1
    else
      1
    end
  end
end
