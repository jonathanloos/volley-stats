class User < ApplicationRecord
  include Roleable

  belongs_to :team

  has_many :events
  has_many :players
  has_many :games, through: :players

  def to_s
    fulle_name
  end

  def fulle_name
    "#{first_name} #{last_name}"
  end
end
