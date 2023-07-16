class User < ApplicationRecord
  include Positionable

  belongs_to :team

  has_many :events
  has_many :players
  has_many :games, through: :players
end
