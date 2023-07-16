class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :team, null: false, foreign_key: true
      t.string :title
      t.string :youtube_link
      t.datetime :date

      t.timestamps
    end
  end
end
