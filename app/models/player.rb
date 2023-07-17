class Player < ApplicationRecord
  include Positionable

  belongs_to :user
  belongs_to :game
  belongs_to :volleyball_set

  validates :position, presence: true

  def to_s
    user.to_s
  end
end
