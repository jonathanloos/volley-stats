class User < ApplicationRecord
  include Positionable

  belongs_to :team

  has_many :events
  has_many :players
  has_many :games, through: :players

  def to_s
    "#{first_name} #{last_name}"
  end
end
