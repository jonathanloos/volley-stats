class CreateVolleyballSets < ActiveRecord::Migration[7.0]
  def change
    create_table :volleyball_sets do |t|
      t.references :game, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :starting_setter_rotation
      t.integer :setter_rotation
      t.integer :rotation, default: 1
      t.integer :position
      t.integer :home_score, default: 0
      t.integer :away_score, default: 0

      t.timestamps
    end
  end
end
