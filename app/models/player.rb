class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game
  belongs_to :volleyball_set
end
