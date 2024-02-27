class AddDefensivePositionToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :back_row_position, :integer
    add_column :players, :front_row_position, :integer

    Player.volleyball_middle.update_all(back_row_position: :left)
    Player.volleyball_middle.update_all(front_row_position: :center)

    Player.volleyball_left_side.update_all(back_row_position: :left)
    Player.volleyball_left_side.update_all(front_row_position: :not_applicable)

    Player.volleyball_right_side.update_all(back_row_position: :right)
    Player.volleyball_right_side.update_all(front_row_position: :right)

    Player.volleyball_setter.update_all(back_row_position: :right)
    Player.volleyball_setter.update_all(front_row_position: :right)
  end
end
