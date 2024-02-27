class AddStartingRotationToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :starting_rotation, :integer
    add_column :players, :starting_libero, :boolean

    Player.update_all("starting_rotation = rotation")
  end
end
