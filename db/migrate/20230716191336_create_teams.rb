class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :year
      t.string :club

      t.timestamps
    end
  end
end
