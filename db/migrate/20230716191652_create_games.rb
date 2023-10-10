class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :home_team, null: false, foreign_key: {to_table: :teams}
      t.references :away_team, null: false, foreign_key: {to_table: :teams}
      t.string :title
      t.string :youtube_link
      t.datetime :date

      t.timestamps
    end
  end
end
