class CreateVolleyballSets < ActiveRecord::Migration[7.0]
  def change
    create_table :volleyball_sets do |t|
      t.references :game, null: false, foreign_key: true
      t.references :serving_team, foreign_key: {to_table: :teams}
      t.references :receiving_team, foreign_key: {to_table: :teams}
      t.integer :starting_setter_rotation
      t.integer :setter_rotation
      t.integer :rotation, default: 1
      t.integer :position
      t.integer :home_score, default: 0
      t.integer :away_score, default: 0
      t.integer :home_time_outs_left, default: 2
      t.integer :away_time_outs_left, default: 2

      t.timestamps
    end
  end
end
