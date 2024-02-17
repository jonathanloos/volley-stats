class CreateTournaments < ActiveRecord::Migration[7.1]
  def change
    create_table :tournaments do |t|
      t.string :title
      t.datetime :date
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :games, :tournament, null: true, foreign_key: true
  end
end
