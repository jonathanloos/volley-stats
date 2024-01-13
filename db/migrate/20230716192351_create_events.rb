class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :volleyball_set, null: false, foreign_key: true
      t.references :player, null: true, foreign_key: true
      t.references :incoming_player, null: true, foreign_key: {to_table: :players}
      t.references :user, null: true, foreign_key: true, optional: true
      t.references :game, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :quality
      t.integer :player_rotation
      t.integer :setter_rotation
      t.integer :rally_skill
      t.integer :skill_point
      t.integer :skill_error
      t.integer :position
      t.integer :role
      t.integer :category
      t.integer :home_score
      t.integer :away_score

      t.timestamps
    end
  end
end
