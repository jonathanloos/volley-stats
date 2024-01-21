# This class will rotate players into their next position
class Players::SubstitutionService < ApplicationService
  def initialize(incoming_player:, player:, undo_action: false)
    @incoming_player = incoming_player
    @player = player
    @undo_action = undo_action
  end

  def call
    Player.transaction do
      rotation = @player.rotation

      unless @undo_action
        # create a substitution event
        @event = Event.new(category: :substitution, player: @player, incoming_player: @incoming_player, volleyball_set: @player.volleyball_set)
        raise unless Events::CreateService.call(event: @event)
      end

      @player.update(status: :bench, rotation: nil)
      @incoming_player.update(status: :on_court, rotation: rotation, role: @incoming_player.user.role)

      true
    end
  rescue => e
    @volleyball_set.errors.add(:base, e)
    false
  end
end
