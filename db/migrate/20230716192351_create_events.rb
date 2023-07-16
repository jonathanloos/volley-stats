class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :volleyball_set, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :rotation
      t.integer :continuation
      t.integer :earned
      t.integer :given

      t.timestamps
    end
  end
end
