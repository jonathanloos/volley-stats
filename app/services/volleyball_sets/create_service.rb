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
      @volleyball_set.save!

      # Create away team player
      @volleyball_set.players << Player.create!(status: :on_court, volleyball_set: @volleyball_set, game: @game, team: @game.away_team)
      
      # Create home team coach for timeouts
      @volleyball_set.players << Player.create!(status: :on_court, volleyball_set: @volleyball_set, game: @game, team: @game.home_team, user: @game.home_team.head_coach, role: :coach)

      # Import player list for home team
      @game.home_team.users.player.each do |user|
        @volleyball_set.players << Player.create!(user: user, status: :bench, volleyball_set: @volleyball_set, game: @game, team: @game.home_team, role: :player)
      end
    end
  rescue => e
    @volleyball_set.errors.add(:base, e)
    false
  end
end
