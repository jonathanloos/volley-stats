class Team < ApplicationRecord
  has_many :users

  def to_s
    "#{name} - #{year}"
  end
end
