# This class will set the lineup for a volleyball set
class VolleyballSets::LineupService < ApplicationService
  def initialize(volleyball_set:, rotation_one_id:, rotation_two_id:, rotation_three_id:, rotation_four_id:, rotation_five_id:, rotation_six_id:, libero_id: nil)
    @volleyball_set = volleyball_set
    @rotation_one_id = rotation_one_id
    @rotation_two_id = rotation_two_id
    @rotation_three_id = rotation_three_id
    @rotation_four_id = rotation_four_id
    @rotation_five_id = rotation_five_id
    @rotation_six_id = rotation_six_id
    @libero_id = libero_id
  end

  def call
    VolleyballSet.transaction do
      # wipe all rotations to avoid validator
      @volleyball_set.players.update_all(rotation: nil)

      # set each rotation manually
      player_1 = @volleyball_set.players.find(@rotation_one_id)
      player_1.update!(rotation: 1, position: player_1.user.position)

      player_2 = @volleyball_set.players.find(@rotation_two_id)
      player_2.update!(rotation: 2, position: player_2.user.position)

      player_3 = @volleyball_set.players.find(@rotation_three_id)
      player_3.update!(rotation: 3, position: player_3.user.position)

      player_4 = @volleyball_set.players.find(@rotation_four_id)
      player_4.update!(rotation: 4, position: player_4.user.position)
      
      player_5 = @volleyball_set.players.find(@rotation_five_id)
      player_5.update!(rotation: 5, position: player_5.user.position)

      player_6 = @volleyball_set.players.find(@rotation_six_id)
      player_6.update!(rotation: 6, position: player_6.user.position)

      if @libero_id.present?
        libero = @volleyball_set.players.find(@libero_id)
        libero.update!(position: :libero)
      end

      true
    end
  rescue => e
    @volleyball_set.errors.add(:base, e)
    false
  end
end
