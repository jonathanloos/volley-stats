class CreateVolleyballSets < ActiveRecord::Migration[7.0]
  def change
    create_table :volleyball_sets do |t|
      t.references :game, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
