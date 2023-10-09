class User < ApplicationRecord
  include Roleable

  belongs_to :team

  has_many :events
  has_many :players
  has_many :games, through: :players

  def to_s
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
