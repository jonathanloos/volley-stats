class AddStartingRotationToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :starting_rotation, :integer
    add_column :players, :starting_libero, :boolean
  end
end
