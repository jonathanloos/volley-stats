class AddDefensivePositionToPlayer < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :back_row_position, :integer
    add_column :players, :front_row_position, :integer

    Player.volleyball_middle.update_all(back_row_position: 5)
    Player.volleyball_middle.update_all(front_row_position: 3)

    Player.volleyball_left_side.update_all(back_row_position: 6)
    Player.volleyball_left_side.update_all(front_row_position: 4)

    Player.volleyball_right_side.update_all(back_row_position: 1)
    Player.volleyball_right_side.update_all(front_row_position: 2)

    Player.volleyball_setter.update_all(back_row_position: 1)
    Player.volleyball_setter.update_all(front_row_position: 2)
  end
end
