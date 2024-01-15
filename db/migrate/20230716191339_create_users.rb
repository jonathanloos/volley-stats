class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :jersey_number
      t.references :team, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end

    add_reference :teams, :head_coach, null: true, foreign_key: {to_table: :users}
    add_reference :teams, :assistant_coach, null: true, foreign_key: {to_table: :users}
  end
end
