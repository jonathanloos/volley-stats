# This class will create a volleyball set
class VolleyballSets::CreateService < ApplicationService
  def initialize(volleyball_set:, game:)
    @volleyball_set = volleyball_set
    @game = game
  end

  def call
    VolleyballSet.transaction do
      @volleyball_set.game = @game
      @volleyball_set.serving_team = @game.home_team
      @volleyball_set.receiving_team = @game.home_team
      @volleyball_set.setter_rotation = @volleyball_set.starting_setter_rotation

      # Create away team player
      @volleyball_set.players << Player.create!(status: :on_court, volleyball_set: @volleyball_set, game: @game, team: @game.away_team)

      # Import player list for home team
      @game.home_team.users.each do |user|
        @volleyball_set.players << Player.create!(user: user, status: :bench, volleyball_set: @volleyball_set, game: @game, team: @game.home_team)
      end

      @volleyball_set.save!
    end
  rescue => e
    @volleyball_set.errors.add(:base, e)
    false
  end
end
