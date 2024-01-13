# This class will create a game
class Games::CreateService < ApplicationService
  def initialize(game)
    @game = game
  end

  def call
    Event.transaction do
      @game.save!

      # create the first three sets
      3.times do { VolleyballSet.create(game: @game, team: @game.team) }
    end
  rescue => e
    @event.errors.add(:base, e)
    false
  end
end
