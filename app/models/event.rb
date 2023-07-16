class Event < ApplicationRecord
  include Positionable

  belongs_to :volleyball_set
  belongs_to :user, optional: true
  belongs_to :game
  belongs_to :team
end
