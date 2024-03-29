class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.references :user, null: true, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.references :volleyball_set, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :status, default: 0
      t.integer :position
      t.integer :role, default: 0
      t.integer :rotation

      t.timestamps
    end
  end
end
