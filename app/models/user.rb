class User < ApplicationRecord
  include Roleable
  include Positionable

  belongs_to :team
  belongs_to :organization, optional: true

  has_many :events
  has_many :players
  has_many :games, through: :players

  validates :role, presence: true
  validates :position, presence: true, if: -> { player? }

  def to_s
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
