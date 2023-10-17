class Team < ApplicationRecord
  has_many :users
  has_many :games
  has_many :volleyball_sets

  def to_s
    "#{name} - #{year}"
  end
end
