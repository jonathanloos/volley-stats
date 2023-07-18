class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :volleyball_set, null: false, foreign_key: true
      t.references :player, null: true, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :rotation
      t.integer :rally_skill
      t.integer :skill_point
      t.integer :skill_error
      t.integer :position
      t.integer :passing_quality

      t.timestamps
    end
  end
end
