class Player < ApplicationRecord
  include Roleable

  belongs_to :user
  belongs_to :game
  belongs_to :volleyball_set

  validates :role, presence: true
  validates :rotation, numericality: {in: 1..6}, if: -> {rotation.present?}

  def to_s
    user.to_s
  end
end
